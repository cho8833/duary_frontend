import 'package:duary/model/couple.dart';

abstract interface class CoupleRepository {
  Future<Couple> getMyCouple();
}