import 'package:duary/model/event.dart';
import 'package:duary/model/member.dart';
import 'package:duary/repository/event_repository.dart';

class EventRepositoryMock implements EventRepository {
  @override
  Future<List<Event>> getComingEvents() async {
    final DateTime now = DateTime.now();
    Future.delayed(const Duration(seconds: 1));
    return [
      Event(
          1,
          now.add(const Duration(hours: 1)),
          now.add(const Duration(hours: 2)),
          "서면 삼바리 앞 / 학생증 챙겨가기!",
          "혜원이랑 조개구이 약속 🤙 ",
          Member("이고은", "circle"),
          false,
          1),
      Event(
          2,
          now.add(const Duration(hours: 3)),
          now.add(const Duration(hours: 4)),
          "사상 타건샵 '몬스터기어매장",
          '타건샵 방문 후 키보드 수령 🤩',
          Member("조현빈", "long"),
          false,
          1),
      Event(
          3,
          now.add(const Duration(hours: 5)),
          now.add(const Duration(hours: 6)),
          "송상현 광장 / 응가가방 챙기기",
          "은동이랑 셋이서 산책하기 🐶",
          Member("이고은", "circle"),
          true,
          1)
    ];
  }

  @override
  Future<List<Event>> getEventByDay(DateTime day) async {
    final DateTime now = DateTime.now();
    Future.delayed(const Duration(seconds: 1));
    return [
      Event(
          1,
          now.add(const Duration(hours: 1)),
          now.add(const Duration(hours: 2)),
          "서면 삼바리 앞 / 학생증 챙겨가기!",
          "혜원이랑 조개구이 약속 🤙 ",
          Member("이고은", "circle"),
          false,
          1),
      Event(
          2,
          now.add(const Duration(hours: 3)),
          now.add(const Duration(hours: 4)),
          "사상 타건샵 '몬스터기어매장",
          '타건샵 방문 후 키보드 수령 🤩',
          Member("조현빈", "long"),
          false,
          1),
      Event(
          3,
          now.add(const Duration(hours: 5)),
          now.add(const Duration(hours: 6)),
          "송상현 광장 / 응가가방 챙기기",
          "은동이랑 셋이서 산책하기 🐶",
          Member("이고은", "circle"),
          true,
          1)
    ];
  }
}
