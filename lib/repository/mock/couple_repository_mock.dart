import 'package:duary/model/couple.dart';
import 'package:duary/model/enums/character.dart';
import 'package:duary/model/enums/member_status.dart';
import 'package:duary/model/member.dart';
import 'package:duary/repository/couple_repository.dart';

class CoupleRepositoryMock implements CoupleRepository {
  @override
  Future<Couple> getMyCouple() async {
    return Future.value(Couple(DateTime(2023, 07, 20),
        Member("조현빈", Character.blue, MemberStatus.couple, 3428835809, "kakao"), Member("이고은", Character.yellow, MemberStatus.couple, 1, "kakao")));
  }
}
