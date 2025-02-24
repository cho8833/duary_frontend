import 'package:duary/model/couple.dart';
import 'package:duary/model/member.dart';
import 'package:duary/repository/couple_repository.dart';

class CoupleRepositoryMock implements CoupleRepository {
  @override
  Future<Couple> getMyCouple() async {
    return Future.value(Couple(DateTime(2023, 07, 20),
        Member("조현빈", "long"), Member("이고은", "circle")));
  }
}
