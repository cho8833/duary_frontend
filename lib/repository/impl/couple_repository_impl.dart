import 'dart:convert';

import 'package:duary/data/start_duary_req.dart';
import 'package:duary/data/start_duary_res.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/repository/couple_repository.dart';
import 'package:duary/support/http_response_handler.dart';
import 'package:duary/support/uri_provider.dart';
import 'package:http/http.dart';
import 'package:duary/data/input_couple_code_req.dart';
import 'package:duary/data/input_couple_code_res.dart';

class CoupleRepositoryImpl with UriProvider, HttpResponseHandler implements CoupleRepository {

  final Client client;

  CoupleRepositoryImpl(this.client);

  @override
  Future<Couple> getMyCouple() async {
    Uri uri = getUri("/couple");

    Response response = await client.get(uri);

    return getData(response, (data) => Couple.fromJson(data)).data;
  }

  @override
  Future<StartDuaryRes> startDuary(StartDuaryReq req) async {
    Uri uri = getUri("/start");

    Response response = await client.post(uri, body: jsonEncode(req.toJson()));

    return getData(response, (p0) => StartDuaryRes.fromJson(p0)).data;
  }

  @override
  Future<InputCoupleCodeRes> inputCoupleCode(InputCoupleCodeReq req) async {
    Uri uri = getUri("/couple/connect");

    Response response = await client.post(uri,body: jsonEncode(req.toJson()));

    return getData(response, (p0) => InputCoupleCodeRes.fromJson(p0)).data;
  }
}