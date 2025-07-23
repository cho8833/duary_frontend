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
  final EventDataNotifier eventDataNotifier = EventDataNotifier();

  // Future caching : 같은 인자로 호출된 비동기 작업이 진행 중이면, 그 작업의 결과를 기다렸다가 반환
  final Map<DateTime, Future<List<Event>>> _eventRequest = {};

  EventProvider(this._eventRepository) {
    DuaryContext duaryContext = DuaryContext();
    duaryContext.me.addListener(() {
      me = duaryContext.me.value;
      eventDataNotifier.clear();
    });
    duaryContext.lover.addListener(() {
      lover = duaryContext.lover.value;
      eventDataNotifier.clear();
    });
    duaryContext.myCouple.addListener(() {
      myCouple = duaryContext.myCouple.value;
      eventDataNotifier.clear();
    });
  }


  Member? me;
  Member? lover;
  Couple? myCouple;

  Future<List<Event>> getEventByDay(DateTime date) async {
    // 캐싱된 이벤트가 있으면 반환
    if (eventDataNotifier.contains(date)) {
      return eventDataNotifier.get(date)!;
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

      eventDataNotifier.set(date, events); // 이벤트 캐싱
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
    await _eventRepository.saveEvent(req).then((event) {
      eventDataNotifier.clear();
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventRepository.deleteEvent(eventId).then((_) {
      eventDataNotifier.clear();
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  void validate(SaveEventReq req) {
    if (req.title.isEmpty) {
      throw ValidationException("제목을 입력해주세요");
    }
    if (req.startDateTime.isAfter(req.endDateTime)) {
      throw ValidationException("시작 시간은 종료 시간 보다 이전일 수 없습니다");
    }
    switch (req.frequency) {
      case Frequency.daily:
        req.weekly = null;
        req.monthly = null;
        req.yearly = null;
      case Frequency.weekly:
        req.daily = null;
        req.monthly = null;
        req.yearly = null;
      case Frequency.monthly:
        req.daily = null;
        req.weekly = null;
        req.yearly = null;
      case Frequency.yearly:
        req.daily = null;
        req.weekly = null;
        req.monthly = null;
      case Frequency.oneTime:
        req.daily = null;
        req.weekly = null;
        req.monthly = null;
        req.yearly = null;
    }
  }
}


class EventDataNotifier extends ChangeNotifier {
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