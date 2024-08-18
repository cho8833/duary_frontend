import 'package:duary/model/couple.dart';
import 'package:duary/repository/couple_repository.dart';

class UserProvider {
  Couple? myCouple;

  final CoupleRepository _coupleRepository;

  UserProvider(this._coupleRepository);

  Future<void> getMyCouple() async {
    await _coupleRepository.getMyCouple().then((couple) {
      myCouple = couple;
    }).catchError((e) {});
  }
}
