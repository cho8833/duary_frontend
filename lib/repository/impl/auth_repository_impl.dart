import 'dart:convert';
import 'package:http/http.dart';
import 'package:duary/data/authorization_token_res.dart';
import 'package:duary/data/sign_in_req.dart';
import 'package:duary/data/sign_up_req.dart';
import 'package:duary/model/member.dart';
import 'package:duary/repository/auth_repository.dart';
import 'package:duary/support/http_response_handler.dart';
import 'package:duary/support/uri_provider.dart';

final class AuthRepositoryImpl with HttpResponseHandler, UriProvider implements AuthRepository {
  AuthRepositoryImpl(this.client, this.interceptedClient);

  final Client interceptedClient;

  final Client client;

  @override
  Future<AuthorizationTokenRes> signIn({SignInReq? req}) async {
    Uri uri = getUri("/auth/signIn");

    Response response = await client.post(uri, body: jsonEncode(req?.toJson()));

    return getData(response, (p0) => AuthorizationTokenRes.fromJson(p0)).data;
  }

  @override
  Future<Member> getUserInfo() async {
    Uri uri = getUri("/auth/me");

    Response response = await interceptedClient.get(uri);


    return getData(response, (p0) => Member.fromJson(p0)).data;
  }
  @override
  Future<AuthorizationTokenRes> reissue(
      String accessToken, String refreshToken) async {
    Uri uri = getUri("/auth/token");

    Map<String, String> header = {"Content-Type": "application/json"};

    Map<String, dynamic> reqBody = {
      "accessToken": accessToken,
      "refreshToken": refreshToken
    };
    Response response =
    await client.post(uri, headers: header, body: jsonEncode(reqBody));

    return getData(response, (p0) => AuthorizationTokenRes.fromJson(p0)).data;
  }

  @override
  Future<AuthorizationTokenRes> signUp(SignUpReq req) async {
    Uri uri = getUri("/auth/signUp");

    Response response = await client.post(uri, body: jsonEncode(req.toJson()));
    return getData(response, (p0) => AuthorizationTokenRes.fromJson(p0)).data;
  }
}