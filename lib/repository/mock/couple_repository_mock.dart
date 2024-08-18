import 'package:duary/model/couple.dart';
import 'package:duary/model/member.dart';
import 'package:duary/repository/couple_repository.dart';

class CoupleRepositoryMock implements CoupleRepository {
  @override
  Future<Couple> getMyCouple() async {
    return Future.value(Couple(DateTime(2023, 07, 20),
        Member(1, "조현빈", 0xFF0024ff, "long"), Member(2, "이고은", 0xFFFFA93A, "circle")));
  }
}
