import 'package:duary/model/couple.dart';
import 'package:duary/model/event.dart';
import 'package:duary/model/member.dart';
import 'package:duary/repository/couple_repository.dart';
import 'package:duary/repository/event_repository.dart';

class DuaryContext {
  final EventRepository _eventRepository;
  final CoupleRepository _coupleRepository;

  // 이벤트 캐싱
  final Map<DateTime, List<Event>> _event = {};

  // Future caching : 같은 인자로 호출된 비동기 작업이 진행 중이면, 그 작업의 결과를 기다렸다가 반환
  final Map<DateTime, Future<List<Event>>> _eventRequest = {};

  Couple? myCouple;

  DuaryContext(this._eventRepository, this._coupleRepository);

  Future<void> getMyCouple(Member me) async {
    await _coupleRepository.getMyCouple().then((couple) {
      myCouple = couple;
      myCouple!.me = me;
      myCouple!.lover =
          myCouple!.members.firstWhere((m) => m.socialId != me.socialId);
    }).catchError((e) {});
  }

  Future<Map<Member, Event?>> getOngoingEvent() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    List<Event> todayEvents = await getEventByDay(today);

    Event? myEvent;
    try {
      myEvent = todayEvents.firstWhere((e) =>
          e.memberSocialId == myCouple!.me.socialId &&
          e.startDateTime.isBefore(now) &&
          e.endDateTime.isAfter(now));
    } catch (_) {}

    Event? loverEvent;
    try {
      loverEvent = todayEvents.firstWhere((e) =>
          e.memberSocialId == myCouple!.lover.socialId &&
          e.startDateTime.isBefore(now) &&
          e.endDateTime.isAfter(now));
    } catch (_) {}

    return {myCouple!.me: myEvent, myCouple!.lover: loverEvent};
  }

  Future<List<Event>> getEventByDay(DateTime date) async {
    // 캐싱된 이벤트가 있으면 반환
    if (_event.containsKey(date)) {
      return _event[date]!;
    }

    // 현재 요청 진행 중이면 그 요청의 결과 기다리고 반환
    if (_eventRequest.containsKey(date)) {
      return _eventRequest[date]!;
    }

    // 새로운 요청이면 Future 캐싱
    DateTime startDate = DateTime(date.year, date.month, date.day);
    DateTime endDate = DateTime(date.year, date.month, date.day + 1);
    final Future<List<Event>> future =
        _eventRepository.getEvent(startDate, endDate).then((events) {
      // 멤버 정보를 이벤트 데이터에 넣어줌
      for (Event event in events) {
        event.member = myCouple!.members
            .firstWhere((member) => member.socialId == event.memberSocialId);
      }

      _event[date] = events; // 이벤트 캐싱
      return events;
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

    return _eventRepository.getEvent(startDate, endDate);
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
}
