import 'package:duary/data/start_duary_req.dart';
import 'package:duary/data/start_duary_res.dart';
import 'package:duary/model/couple.dart';

abstract interface class CoupleRepository {
  Future<Couple> getMyCouple();

  Future<StartDuaryRes> startDuary(StartDuaryReq req);


}