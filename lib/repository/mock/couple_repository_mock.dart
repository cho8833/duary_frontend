import 'package:duary/data/start_duary_req.dart';
import 'package:duary/data/start_duary_res.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/model/enums/character.dart';
import 'package:duary/model/member.dart';
import 'package:duary/repository/couple_repository.dart';

class CoupleRepositoryMock implements CoupleRepository {
  @override
  Future<Couple> getMyCouple() async {
    return Future.value(Couple(
        "84ad69ea-1937-4aa0-872a-9dccc2274c9e",
        DateTime(2023, 07, 20),
        [
          Member(
            "조현빈",
            Character.blue,
            "84ad69ea-1937-4aa0-872a-9dccc2274c9e",
            DateTime(2000, 08, 13),
            "3428835809",
            "kakao",
          ),
          Member(
            "이고은",
            Character.yellow,
            "84ad69ea-1937-4aa0-872a-9dccc2274c9e",
            DateTime(1999, 04, 19),
            "1",
            "kakao",
          )
        ],
        "asdf"));
  }

  @override
  Future<StartDuaryRes> startDuary(StartDuaryReq req) {
    // TODO: implement startDuary
    throw UnimplementedError();
  }
}
