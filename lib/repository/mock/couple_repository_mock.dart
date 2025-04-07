import 'package:duary/data/start_duary_req.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/model/enums/character.dart';
import 'package:duary/model/member.dart';
import 'package:duary/repository/couple_repository.dart';

class CoupleRepositoryMock implements CoupleRepository {
  @override
  Future<Couple> getMyCouple() async {
    return Future.value(Couple(DateTime(2023, 07, 20), [
      Member("조현빈", Character.blue, 3428835809, "kakao",
          "84ad69ea-1937-4aa0-872a-9dccc2274c9e"),
      Member("이고은", Character.yellow, 1, "kakao",
          "84ad69ea-1937-4aa0-872a-9dccc2274c9e")
    ]));
  }

  @override
  Future<Couple> startDuary(StartDuaryReq req) {
    return Future.value(Couple(DateTime(2023, 07, 20), [
      Member("조현빈", Character.blue, 3428835809, "kakao",
          "84ad69ea-1937-4aa0-872a-9dccc2274c9e"),
      Member("이고은", Character.yellow, 1, "kakao",
          "84ad69ea-1937-4aa0-872a-9dccc2274c9e")
    ]));
  }
}
