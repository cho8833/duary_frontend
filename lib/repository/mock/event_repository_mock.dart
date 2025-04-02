import 'package:duary/model/event.dart';
import 'package:duary/repository/event_repository.dart';

class EventRepositoryMock implements EventRepository {

  static final DateTime now = DateTime.now();

  static Event dummy1(DateTime date) {
    return Event(
      1,
      date.copyWith(hour: 4),
      date.copyWith(hour: 5),
      "${date.month}/${date.day} 송상현 광장 / 응가가방 챙기기",
      1,
      true,
      1,
      false,
      content: "${date.month}/${date.day} 은동이랑 셋이서 산책하기 🐶",
    );
  }

  static Event dummy2(DateTime date) {
    return Event(
      2,
      date.copyWith(hour: 12),
      date.copyWith(hour: 16),
      "${date.month}/${date.day} 사상 타건샵 '몬스터기어매장",
      3428835809,
      false,
      1,
      false,
      content: '${date.month}/${date.day} 타건샵 방문 후 키보드 수령 🤩',
    );
  }

  static Event dummy3(DateTime date) {
    return Event(
      3,
      date.copyWith(hour: 13),
      date.copyWith(hour: 14),
      "송상현 광장 / 응가가방 챙기기",
      1,
      true,
      1,
      false,
      content: "${date.month}/${date.day} 은동이랑 셋이서 산책하기 🐶",
    );
  }
  static Event dummy4(DateTime date) {
    return Event(
      4,
      date.copyWith(hour: 9),
      date.copyWith(hour: 10),
      "${date.month}/${date.day} 제목",
      1,
      false,
      1,
      false,
      content: "내용",
    );
  }

  @override
  Future<List<Event>> getComingEvents() async {
    Future.delayed(const Duration(seconds: 1));
    return [
      dummy1(now),
      dummy2(now),
      dummy3(now)
    ];
  }

  @override
  Future<List<Event>> getEvent(DateTime startDate, DateTime endDate) async {
    final DateTime date =
        DateTime(startDate.year, startDate.month, startDate.day);
    Future.delayed(const Duration(seconds: 1));
    return [
      // dummy1(date),
      dummy2(date),
      dummy3(date),
      // dummy4(date)
    ];
  }
}
