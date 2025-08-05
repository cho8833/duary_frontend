import 'dart:convert';

import 'package:duary/data/start_duary_req.dart';
import 'package:duary/data/duary_info_res.dart';
import 'package:duary/data/update_couple_req.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/repository/couple_repository.dart';
import 'package:duary/support/http_response_handler.dart';
import 'package:duary/support/iso8601_time_zone_formatter.dart';
import 'package:duary/support/uri_provider.dart';
import 'package:http/http.dart';
import 'package:duary/data/input_couple_code_req.dart';

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
  Future<DuaryInfoRes> startDuary(StartDuaryReq req) async {
    Uri uri = getUri("/start");

    Response response = await client.post(uri, body: jsonEncode(req.toJson()));

    return getData(response, (p0) => DuaryInfoRes.fromJson(p0)).data;
  }

  @override
  Future<DuaryInfoRes> inputCoupleCode(InputCoupleCodeReq req) async {
    Uri uri = getUri("/couple/connect");

    Response response = await client.post(uri,body: jsonEncode(req.toJson()));

    return getData(response, (p0) => DuaryInfoRes.fromJson(p0)).data;
  }

  @override
  Future<Couple> updateCouple(UpdateCoupleReq req) async {
    Uri uri = getUri("/couple", queryParameters: {
      "relationDate": const ISO8601TimeZoneFormatter().toJson(req.relationDate)
    });

    Response response = await client.put(uri, body: jsonEncode(req.toJson()));

    return getData(response, (p0) => Couple.fromJson(p0)).data;
  }

  @override
  Future<DuaryInfoRes> disconnectCouple() async {
    Uri uri = getUri("/couple/disconnect");

    Response response = await client.post(uri);

    return getData(response, (p0) => DuaryInfoRes.fromJson(p0)).data;
  }
}