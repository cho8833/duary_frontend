import 'package:duary/data/input_couple_code_req.dart';
import 'package:duary/data/start_duary_req.dart';
import 'package:duary/data/duary_info_res.dart';
import 'package:duary/data/update_couple_req.dart';
import 'package:duary/model/couple.dart';

abstract interface class CoupleRepository {
  Future<Couple> getMyCouple();

  Future<DuaryInfoRes> startDuary(StartDuaryReq req);

  Future<DuaryInfoRes> inputCoupleCode(InputCoupleCodeReq req);

  Future<Couple> updateCouple(UpdateCoupleReq req);

  Future<DuaryInfoRes> disconnectCouple();

}