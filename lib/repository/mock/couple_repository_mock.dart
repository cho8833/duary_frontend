import 'package:duary/data/input_couple_code_req.dart';
import 'package:duary/data/input_couple_code_res.dart';
import 'package:duary/data/start_duary_req.dart';
import 'package:duary/data/duary_info_res.dart';
import 'package:duary/data/update_couple_req.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/model/enums/alarm_offset.dart';
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
            AlarmOffset.none,
            AlarmOffset.atTime
          ),
          Member(
            "이고은",
            Character.yellow,
            "84ad69ea-1937-4aa0-872a-9dccc2274c9e",
            DateTime(1999, 04, 19),
            "1",
            "kakao",
            AlarmOffset.none,
            AlarmOffset.atTime
          )
        ],
        "asdf"));
  }

  @override
  Future<DuaryInfoRes> startDuary(StartDuaryReq req) {
    // TODO: implement startDuary
    throw UnimplementedError();
  }

  @override
  Future<InputCoupleCodeRes> inputCoupleCode(InputCoupleCodeReq req) {
    throw UnimplementedError();
  }

  @override
  Future<Couple> updateCouple(UpdateCoupleReq req) {
    // TODO: implement updateCouple
    throw UnimplementedError();
  }
}
