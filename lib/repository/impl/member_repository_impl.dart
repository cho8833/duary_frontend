import 'dart:convert';

import 'package:duary/data/update_member_req.dart';
import 'package:duary/data/update_member_res.dart';
import 'package:http/http.dart';
import 'package:duary/repository/member_repository.dart';
import 'package:duary/support/http_response_handler.dart';
import 'package:duary/support/uri_provider.dart';

class MemberRepositoryImpl with UriProvider, HttpResponseHandler implements MemberRepository {

  Client authorizedClient;

  MemberRepositoryImpl(this.authorizedClient);

  @override
  Future<UpdateMemberRes> updateMember(UpdateMemberReq req) async {
Uri uri = getUri("/member");

Response response = await authorizedClient.post(uri, body: jsonEncode(req.toJson()));

return getData(response, (p0) => UpdateMemberRes.fromJson(p0)).data;
  }
}