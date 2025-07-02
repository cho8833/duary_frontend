import 'package:duary/model/enums/frequency.dart';
import 'package:duary/model/event.dart';
import 'package:duary/repository/event_repository.dart';

class EventRepositoryMock implements EventRepository {

  static final DateTime now = DateTime.now();

  static Event dummy2(DateTime date) {
    return Event(
      "eventId2",
      "coupleId2",
      "3428835809-kakao",
      date.copyWith(hour: 12),
      date.copyWith(hour: 16),
      "${date.month}/${date.day} 사상 타건샵 '몬스터기어매장",
      Frequency.oneTime,
      false,
      false,
      content: '${date.month}/${date.day} 타건샵 방문 후 키보드 수령 🤩',
    );
  }

  static Event dummy3(DateTime date) {
    return Event(
      "eventId3",
      "coupleId3",
      "4269846273-kakao",
      date.copyWith(hour: 13),
      date.copyWith(hour: 14),
      "송상현 광장 / 응가가방 챙기기",
      Frequency.oneTime,
      true,
      false,
      content: "${date.month}/${date.day} 은동이랑 셋이서 산책하기 🐶",
    );
  }
  static Event dummy4(DateTime date) {
    return Event(
      "eventId4",
      "coupleId4",
      "4269846273-kakao",
      date.copyWith(hour: 9),
      date.copyWith(hour: 10),
      "${date.month}/${date.day} 제목",
      Frequency.oneTime,
      false,
      false,
      content: "내용",
    );
  }

  static Event dummy1(DateTime date) {
    return Event(
      "eventId1",
      "coupleId1",
      "4269846273-kakao",
      date.copyWith(hour: 8, minute: 45),
      date.copyWith(hour: 10, minute: 0),
      "${date.month}/${date.day} 송상현 광장 / 응가가방 챙기기",
      Frequency.oneTime,
      true,
      false,
      content: "${date.month}/${date.day} 은동이랑 셋이서 산책하기 🐶",
    );
  }

  static Event dummy5(DateTime date) {
    return Event(
      "eventId5",
      "coupleId5",
      "3428835809-kakao",
      date.copyWith(hour: 9, minute: 0),
      date.copyWith(hour: 10, minute: 0),
      "${date.month}/${date.day} 송상현 광장 / 응가가방 챙기기",
      Frequency.oneTime,
      false,
      false,
      content: "${date.month}/${date.day} 은동이랑 셋이서 산책하기 🐶",
    );
  }

  @override
  Future<List<Event>> getEvent(String coupleId, DateTime startDate, DateTime endDate) async {
    final DateTime date =
        DateTime(startDate.year, startDate.month, startDate.day);
    Future.delayed(const Duration(seconds: 1));
    return [
      dummy1(date),
      dummy3(date),
      dummy2(date),
      dummy4(date),
      dummy5(date),
    ];
  }
}
