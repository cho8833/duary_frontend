import 'dart:convert';

import 'package:http/http.dart';
import 'package:duary/base/server_response.dart';
import 'package:duary/data/page_req.dart';
import 'package:duary/model/enums/role.dart';
import 'package:duary/model/member.dart';
import 'package:duary/repository/member_repository.dart';
import 'package:duary/support/http_response_handler.dart';
import 'package:duary/support/uri_provider.dart';

class MemberRepositoryImpl with UriProvider, HttpResponseHandler implements MemberRepository {

  Client authorizedClient;

  MemberRepositoryImpl(this.authorizedClient);

  @override
  Future<PagedData<Member>> getList(PageReq req) async {
    Uri uri = getUri("/member");

    Response response = await authorizedClient.get(uri);

    return getPagedData(response, (p0) => Member.fromJson(p0)).data;
  }

  @override
  Future<void> updateRole(int id, Role role) async {
    Uri uri = getUri("/member", queryParameters: {
      "id": id.toString()
    });
    Map<String, dynamic> body = {
      "role": role.toJson()
    };
    Response response = await authorizedClient.post(uri, body: jsonEncode(body));

    checkResponse(response);
  }

}