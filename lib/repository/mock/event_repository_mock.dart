import 'package:duary/data/event_req.dart';
import 'package:duary/model/enums/frequency.dart';
import 'package:duary/model/event.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/repository/event_repository.dart';

class EventRepositoryMock implements EventRepository {
  static final DateTime now = DateTime.now();

  @override
  Future<List<Event>> getEvent(
      String coupleId, DateTime startDate, DateTime endDate) async {
    final DateTime date =
        DateTime(startDate.year, startDate.month, startDate.day);

    DuaryContext duaryContext = DuaryContext();

    Member me = duaryContext.me.value!;

    Member lover = duaryContext.lover.value!;

    Event dummy2(DateTime date) {
      return Event(
        "12~16-me",
        "coupleId",
        me.getId(),
        date.copyWith(hour: 12),
        date.copyWith(hour: 16),
        "${date.month}/${date.day} 사상 타건샵 '몬스터기어매장",
        Frequency.oneTime,
        false,
        true,
        content: '${date.month}/${date.day} 타건샵 방문 후 키보드 수령 🤩',
      );
    }

    Event dummy3(DateTime date) {
      return Event(
        "10:30~11:30-lover",
        "coupleId",
        lover.getId(),
        date.copyWith(hour: 10, minute: 30),
        date.copyWith(hour: 11, minute: 30),
        "송상현 광장 / 응가가방 챙기기",
        Frequency.oneTime,
        true,
        true,
        content: "${date.month}/${date.day} 은동이랑 셋이서 산책하기 🐶",
      );
    }

    Event dummy4(DateTime date) {
      return Event(
        "9~10-me",
        "coupleId",
        me.getId(),
        date.copyWith(hour: 9),
        date.copyWith(hour: 10),
        "${date.month}/${date.day} 제목",
        Frequency.oneTime,
        false,
        false,
        content: "내용",
      );
    }

    Event dummy1(DateTime date) {
      return Event(
        "8:45~10:00-lover",
        "coupleId",
        lover.getId(),
        date.copyWith(hour: 8, minute: 45),
        date.copyWith(hour: 10, minute: 0),
        "${date.month}/${date.day} 송상현 광장 / 응가가방 챙기기",
        Frequency.oneTime,
        true,
        false,
        content: "${date.month}/${date.day} 은동이랑 셋이서 산책하기 🐶",
      );
    }

    Event dummy5(DateTime date) {
      return Event(
        "9~10-lover1",
        "coupleId",
        lover.getId(),
        date.copyWith(hour: 9, minute: 0),
        date.copyWith(hour: 10, minute: 0),
        "${date.month}/${date.day} 송상현 광장 / 응가가방 챙기기",
        Frequency.oneTime,
        false,
        false,
        content: "${date.month}/${date.day} 은동이랑 셋이서 산책하기 🐶",
      );
    }

    Event dummy6(DateTime date) {
      return Event(
        "9~다음날9-lover2${date.toString()}",
        "coupleId",
        lover.getId(),
        date.copyWith(hour: 12, minute: 0),
        date.copyWith(day: date.day + 1, hour: 9, minute: 0),
        "${date.month}/${date.day} 응가가방 챙기기",
        Frequency.oneTime,
        false,
        false,
        content: "${date.month}/${date.day} 은동이랑 셋이서 산책하기 🐶",
      );
    }

    Event dummy9(DateTime date) {
      return Event(
        "전날9~10-lover2${date.toString()}",
        "coupleId",
        lover.getId(),
        date.copyWith(day: date.day - 1, hour: 12, minute: 0),
        date.copyWith(hour: 9, minute: 0),
        "${date.month}/${date.day} 응가가방 챙기기",
        Frequency.oneTime,
        false,
        false,
        content: "${date.month}/${date.day} 은동이랑 셋이서 산책하기 🐶",
      );
    }

    Event dummy7(DateTime date) {
      return Event(
        "9~10-me1",
        "coupleId",
        me.getId(),
        date.copyWith(hour: 9, minute: 0),
        date.copyWith(hour: 10, minute: 0),
        "${date.month}/${date.day} 응가가방 챙기기",
        Frequency.oneTime,
        false,
        false,
        content: "${date.month}/${date.day} 은동이랑 셋이서 산책하기 🐶",
      );
    }

    Event dummy8(DateTime date) {
      return Event(
        "9~10-me2",
        "coupleId",
        me.getId(),
        date.copyWith(hour: 9, minute: 0),
        date.copyWith(hour: 10, minute: 0),
        "${date.month}/${date.day} 응가가방 챙기기",
        Frequency.oneTime,
        false,
        false,
        content: "${date.month}/${date.day} 은동이랑 셋이서 산책하기 🐶",
      );
    }

    Future.delayed(const Duration(seconds: 1));
    return [
      dummy1(date),
      dummy3(date),
      dummy2(date),
      dummy4(date),
      dummy5(date),
      dummy6(date),
      dummy7(date),
      dummy8(date),
      dummy9(date)
    ];
  }

  @override
  Future<Event> saveEvent(SaveEventReq req) {
    // TODO: implement saveEvent
    throw UnimplementedError();
  }

  @override
  Future<void> deleteEvent(String eventId) {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }

  @override
  Future<Event> editEvent(String id, SaveEventReq req) {
    // TODO: implement editEvent
    throw UnimplementedError();
  }
}
