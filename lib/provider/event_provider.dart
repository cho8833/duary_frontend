import 'package:device_calendar/device_calendar.dart' as dc;
import 'package:duary/base/ws_data.dart';
import 'package:duary/data/event_req.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/model/enums/character.dart';
import 'package:duary/model/event.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/repository/apple_calendar_repository.dart';
import 'package:duary/repository/event_repository.dart';
import 'package:duary/repository/impl/websocket_handler.dart';
import 'package:duary/support/custom_exception.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  final EventRepository _eventRepository;
  final AppleCalendarRepository appleCalendarRepository;

  Member? me;
  Member? lover;
  Couple? myCouple;

  // 이벤트 캐싱
  final Map<DateTime, Set<Event>> _eventMap = {};

  // Future caching : 같은 인자로 호출된 비동기 작업이 진행 중이면, 그 작업의 결과를 기다렸다가 반환
  final Map<DateTime, Future<List<Event>>> _eventRequest = {};

  EventProvider(this._eventRepository, this.appleCalendarRepository) {
    DuaryContext duaryContext = DuaryContext();
    duaryContext.me.addListener(() {
      me = duaryContext.me.value;
      if (me == null) {
        // me 가 null 로 바뀌면 sign out or withdrawal
        lover = null;
        myCouple = null;
      }
      _clearData();
    });
    duaryContext.lover.addListener(() {
      lover = duaryContext.lover.value;
      _clearData();
    });
    duaryContext.myCouple.addListener(() {
      myCouple = duaryContext.myCouple.value;
      _clearData();
    });

    WebSocketHandler wsHandler = WebSocketHandler();
    wsHandler.eventMsgNotifier.addListener(() {
      _handleWS(wsHandler.eventMsgNotifier.value);
    });
  }

  /// 특정 날짜의 이벤트를 가져옵니다. 캐시가 없으면 월 단위로 가져와 채웁니다.
  Future<List<Event>> getEventByDay(DateTime date) async {
    if (myCouple == null) return [];

    final dayKey = DateUtils.dateOnly(date);

    // 1. 일별 캐시 확인
    if (_eventMap.containsKey(dayKey)) {
      return _eventMap[dayKey]!.toList();
    }

    // 2. 월 단위 요청이 이미 진행 중인지 확인
    final monthKey = DateTime(date.year, date.month, 1);
    if (_eventRequest.containsKey(monthKey)) {
      // 진행 중인 월 단위 요청을 기다린 후, 캐시에서 다시 데이터를 가져옵니다.
      await _eventRequest[monthKey]!;
      return _eventMap[dayKey]?.toList() ?? [];
    }

    // 3. 캐시도 없고, 진행 중인 요청도 없으면 월 단위로 데이터를 가져옵니다.
    await _fetchAndCacheMonth(date);

    // 월 단위 캐싱이 완료된 후, 해당 날짜의 데이터를 반환합니다.
    return _eventMap[dayKey]?.toList() ?? [];
  }

  /// 특정 월의 모든 이벤트를 가져옵니다. 캐시를 우선적으로 확인합니다.
  Future<Map<DateTime, List<Event>>> getEventByMonth(DateTime month) async {
    if (myCouple == null) return {}; // 커플 정보가 없으면 빈 맵을 반환

    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final monthKey = DateTime(month.year, month.month, 1);

    if (_eventRequest.containsKey(monthKey)) {
      // 진행 중인 월 단위 요청이 완료될 때까지 기다립니다.
      // 이 Future가 완료되면 notifier는 채워진 상태가 됩니다.
      await _eventRequest[monthKey]!;
    }

    // 해당 월의 모든 날짜가 캐시되어 있는지 확인
    bool isFullyCached = true;
    for (int i = 1; i <= daysInMonth; i++) {
      final day = DateTime(month.year, month.month, i);
      if (!_eventMap.containsKey(day)) {
        isFullyCached = false;
        break;
      }
    }

    if (!isFullyCached) {
      await _fetchAndCacheMonth(month);
    }

    final Map<DateTime, List<Event>> resultMap = {};
    for (int i = 1; i <= daysInMonth; i++) {
      final day = DateTime(month.year, month.month, i);
      resultMap[day] = _eventMap[day]?.toList() ?? [];
    }

    return resultMap;
  }

  /// 월 단위로 서버에서 이벤트를 가져와 일별로 캐싱
  Future<List<Event>> _fetchAndCacheMonth(DateTime month) async {
    if (myCouple == null) return Future.value([]);

    final monthKey = DateTime(month.year, month.month, 1);

    if (_eventRequest.containsKey(monthKey)) {
      return _eventRequest[monthKey]!;
    }

    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 1);

    final List<Future<List<Event>>> eventFutures = [];

    eventFutures
        .add(_eventRepository.getEvent(myCouple!.id, startDate, endDate));

    eventFutures.add(_getAppleEvents(
        me?.syncedAppleCalendar ?? [],
        me!.getId(),
        lover?.getId(),
        startDate,
        endDate));

    final future = Future.wait(eventFutures).then((result) {
      List<Event> events = result.expand((e) => e).toList();
      _initMemberInEvents(events);

      // 1. 가져온 이벤트를 날짜별로 임시 분류 (기존과 동일)
      final Map<DateTime, Set<Event>> tempMonthlyCache = {};
      for (final event in events) {
        DateTime currentDay = DateUtils.dateOnly(event.startDateTime);
        final lastDay = DateUtils.dateOnly(event.endDateTime);

        while (!currentDay.isAfter(lastDay)) {
          if (currentDay.year == month.year &&
              currentDay.month == month.month) {
            tempMonthlyCache.putIfAbsent(currentDay, () => {}).add(event);
          }
          currentDay = currentDay.add(const Duration(days: 1));
        }
      }

      // 2.해당 월의 모든 날짜에 대해 캐시를 설정합니다.
      final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
      for (int i = 1; i <= daysInMonth; i++) {
        final day = DateTime(month.year, month.month, i);

        // 임시 캐시에 해당 날짜의 이벤트가 있으면 가져오고, 없으면 빈 리스트를 사용합니다.
        final dailyEvents = tempMonthlyCache[day]?.toList() ?? [];

        // 이벤트 유무와 관계없이 '모든 날짜'에 대해 notifier에 set합니다.
        _eventMap[day] = Set.of(dailyEvents);
      }
      notifyListeners();

      // 이 메소드의 반환 타입 유지를 위해 원본 events 리스트를 반환합니다.
      return events;
    }).catchError((e) {
      print(e);
      throw e;
    }).whenComplete(() {
      _eventRequest.remove(monthKey);
    });

    _eventRequest[monthKey] = future;
    return future;
  }

  Future<bool> requestApplePermission() async {
    return await appleCalendarRepository.requestPermission();
  }

  Future<bool> getApplePermission() async {
    return await appleCalendarRepository.getPermission();
  }

  Future<List<dc.Calendar>> getAppleCalendars() {
    return appleCalendarRepository.getCalendars();
  }

  Future<List<Event>> _getAppleEvents(List<AppleCalendar> calendars, String memberId, String? loverId,
      DateTime startDate, DateTime endDate) async {
    if (calendars.isEmpty) {
      return [];
    }
    final List<List<Event>> futures = await Future.wait(calendars.map((c) =>
        appleCalendarRepository.getEvent(c, memberId, loverId, startDate, endDate)));

    List<Event> flattened = futures.expand((e) => e).toList();

    return flattened;
  }

  List<Event> _initMemberInEvents(List<Event> events) {
    List<Event> temp = [];
    final noneMember = Member("none", "none", character: Character.none);
    for (Event event in events) {
      try {
        event.member = myCouple!.members
            .firstWhere((member) => member.getId() == event.createdBy);
      } catch (_) {
        event.member = noneMember;
        // createdby 와 member 가 매핑되는 event가 없으면 잘못된 데이터로 간주하고 무시
      }
      temp.add(event);
    }
    return temp;
  }

  Future<void> saveEvent(SaveEventReq req) async {
    req.validate();
    await _eventRepository.saveEvent(req).then((event) {
      _clearData();
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  Future<Event?> editEvent(String id, SaveEventReq req) async {
    req.validate();
    return await _eventRepository.editEvent(id, req).then((event) {
      _initMemberInEvents([event]);
      _clearData();
      return event;
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  Future<void> deleteEvent(Event event) async {
    await _eventRepository.deleteEvent(event.id).then((_) {
      _clearData();
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  void _handleWS(WebSocketData<Event>? data) {
    _clearData();
  }

  void _clearData() {
    _eventMap.clear();
    notifyListeners();
  }
}