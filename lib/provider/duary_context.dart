import 'package:duary/model/couple.dart';
import 'package:duary/model/member.dart';
import 'package:duary/repository/couple_repository.dart';

class DuaryContext {

  final CoupleRepository _coupleRepository;

  Couple? myCouple;

  DuaryContext(this._coupleRepository);

  Future<void> getMyCouple(Member me, {void Function(Couple)? onSuccess}) async {
    await _coupleRepository.getMyCouple().then((couple) {
      myCouple = couple;
      myCouple!.me = me;
      myCouple!.lover =
          myCouple!.members.firstWhere((m) => m.socialId != me.socialId);
      onSuccess?.call(myCouple!);
    }).catchError((e) {});
  }


}
