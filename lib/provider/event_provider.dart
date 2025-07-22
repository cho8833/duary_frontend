import 'package:duary/data/save_event_req.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/model/enums/frequency.dart';
import 'package:duary/model/event.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/repository/event_repository.dart';
import 'package:duary/support/custom_exception.dart';
import 'package:flutter/material.dart';

class EventProvider {

  final EventRepository _eventRepository;

  // 이벤트 캐싱
  final EventData eventData = EventData();

  // Future caching : 같은 인자로 호출된 비동기 작업이 진행 중이면, 그 작업의 결과를 기다렸다가 반환
  final Map<DateTime, Future<List<Event>>> _eventRequest = {};

  EventProvider(this._eventRepository) {
    DuaryContext duaryContext = DuaryContext();
    duaryContext.me.addListener(() {
      me = duaryContext.me.value;
      eventData.clear();
    });
    duaryContext.lover.addListener(() {
      lover = duaryContext.lover.value;
      eventData.clear();
    });
    duaryContext.myCouple.addListener(() {
      myCouple = duaryContext.myCouple.value;
      eventData.clear();
    });
  }


  Member? me;
  Member? lover;
  Couple? myCouple;

  Future<Map<Member, Event?>> getOngoingEvent() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    List<Event> todayEvents = await getEventByDay(today);

    Event? myEvent;

    try {
      myEvent = todayEvents.firstWhere((e) =>
      e.createdBy == me!.socialId &&
          e.startDateTime.isBefore(now) &&
          e.endDateTime.isAfter(now));
    } catch (_) {}

    Event? loverEvent;
    try {
      loverEvent = todayEvents.firstWhere((e) =>
      e.createdBy == lover!.socialId &&
          e.startDateTime.isBefore(now) &&
          e.endDateTime.isAfter(now));
    } catch (_) {}

    return {me!: myEvent, lover!: loverEvent};
  }

  Future<List<Event>> getEventByDay(DateTime date) async {
    // 캐싱된 이벤트가 있으면 반환
    if (eventData.contains(date)) {
      return eventData.get(date)!;
    }

    // 현재 요청 진행 중이면 그 요청의 결과 기다리고 반환
    if (_eventRequest.containsKey(date)) {
      return _eventRequest[date]!;
    }

    // 새로운 요청이면 Future 캐싱
    DateTime startDate = DateTime(date.year, date.month, date.day);
    DateTime endDate = DateTime(date.year, date.month, date.day + 1);
    final Future<List<Event>> future =
    _eventRepository.getEvent(myCouple!.id, startDate, endDate).then((events) {
      // 멤버 정보를 이벤트 데이터에 넣어줌
      events = _initMemberInEvents(events);

      // 이벤트 정렬
      events.sort((e1, e2) {
        return e1.startDateTime.compareTo(e2.startDateTime);
      });

      eventData.set(date, events); // 이벤트 캐싱
      return events;
    }).catchError((e) {
      print(e);
      throw e;
    }).whenComplete(() {
      // 요청이 완료되면 Future cache 에서 제거
      _eventRequest.remove(date);
    });

    _eventRequest[date] = future;

    return future;
  }

  // TODO: 여기서 Map 에 날짜별로 분류해서 주는게 좋지 않을까?
  // month 단위는 Caching 하지 않음
  Future<List<Event>> getEventByMonth(DateTime month) async {
    DateTime startDate = DateTime(month.year, month.month);
    DateTime endDate = DateTime(month.year, month.month + 1);


    List<Event> events = await _eventRepository.getEvent(myCouple!.id, startDate, endDate);

    _initMemberInEvents(events);
    return events;
  }

  Future<List<Event>> getComingEvent() async {
    final DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // 오늘 이벤트들을 불러와서 시작 시간 기준으로 정렬 후, 현재 시간보다 뒤인 이벤트 3개를 고름
    List<Event> todayEvents = await getEventByDay(today);
    List<Event> afterNow =
    todayEvents.where((e) => e.startDateTime.isAfter(now)).toList();
    afterNow.sort((e1, e2) => e1.startDateTime.compareTo(e2.startDateTime));

    // 골랐을 때 3개 보다 적으면 내일 이벤트까지 불러옴
    // 내일 이벤트까지 불러왔는데도 3개보다 적으면 어쩔 수 없음
    if (afterNow.length < 3) {
      int need = 3 - afterNow.length;
      DateTime tomorrow = today.add(const Duration(days: 1));
      List<Event> tomorrowEvents = await getEventByDay(tomorrow);
      tomorrowEvents
          .sort((e1, e2) => e1.startDateTime.compareTo(e2.startDateTime));
      afterNow.addAll(tomorrowEvents.take(need));
    }

    return afterNow;
  }

  List<Event> _initMemberInEvents(List<Event> events) {
    List<Event> temp = [];
    for (Event event in events) {
      try {
        event.member = myCouple!.members
            .firstWhere((member) => member.getId() == event.createdBy);
        temp.add(event);
      } catch (_) {
        // createdby 와 member 가 매핑되는 event가 없으면 잘못된 데이터로 간주하고 무시
      }
    }
    return temp;
  }

  Future<void> saveEvent(SaveEventReq req) async {
    validate(req);
    if (req.frequency == Frequency.yearly) {
      req.yearly = YearlyRecurrence(req.startDateTime.month, req.startDateTime.day);
    }
    await _eventRepository.saveEvent(req).then((event) {
      eventData.clear();
    }).catchError((e) {
      throw ServerResponseException(e);
    });
  }

  void validate(SaveEventReq req) {
    if (req.title.isEmpty) {
      throw ValidationException("제목을 입력해주세요");
    }
  }
}


class EventData extends ChangeNotifier {
  final Map<DateTime, List<Event>> eventMap = {};

  List<Event>? get(DateTime date) {
    return eventMap[date];
  }

  void set(DateTime date, List<Event> events) {
    eventMap[date] = events;
    notifyListeners();
  }

  void clear() {
    eventMap.clear();
    notifyListeners();
  }

  bool contains(DateTime date) {
    return eventMap.containsKey(date);
  }
}