import 'dart:convert';
import 'package:duary/data/duary_info_res.dart';
import 'package:duary/data/dummy_sign_in_req.dart';
import 'package:http/http.dart';
import 'package:duary/data/authorization_token_res.dart';
import 'package:duary/data/sign_in_req.dart';
import 'package:duary/repository/auth_repository.dart';
import 'package:duary/support/http_response_handler.dart';
import 'package:duary/support/uri_provider.dart';

final class AuthRepositoryImpl
    with HttpResponseHandler, UriProvider
    implements AuthRepository {
  AuthRepositoryImpl(this.client, this.interceptedClient);

  final Client interceptedClient;

  final Client client;

  @override
  Future<DuaryInfoRes> signInWithKakaoTalk(SignInReq req) async {

    Uri uri = getUri("/auth/signin/kakao");

    Response response =
        await client.post(uri, body: jsonEncode(req.toJson()));

    return getData(response, (p0) => DuaryInfoRes.fromJson(p0)).data;
  }

  @override
  Future<DuaryInfoRes> signInWithApple(SignInReq req) async {

    Uri uri = getUri("/auth/signin/apple");
    
    Response response = await client.post(uri, body: jsonEncode(req.toJson()));

    return getData(response, (p) => DuaryInfoRes.fromJson(p)).data;
  }

  @override
  Future<DuaryInfoRes> signInWithToken(SignInReq req) async {
    Uri uri = getUri("/auth/signin/token");

    Response response = await interceptedClient.post(uri, body: jsonEncode(req.toJson()));

    return getData(response, (p0) => DuaryInfoRes.fromJson(p0)).data;
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
  Future<DuaryInfoRes> dummySignIn(DummySignInReq req) async {
    Uri uri = getUri("/auth/signin/dummy");

    Response response = await client.post(uri, body: jsonEncode(req.toJson()));

    return getData(response, (p0) => DuaryInfoRes.fromJson(p0)).data;
  }

  Future<void> signOut() async {
    Uri uri = getUri("/auth/signout");

    Response response = await interceptedClient.post(uri);

    checkResponse(response);
  }

  @override
  Future<DuaryInfoRes> signInWithGoogle(SignInReq req) async {
    Uri uri = getUri("/auth/signin/google");

    Response response = await client.post(uri, body: jsonEncode(req.toJson()));

    return getData(response, (p0) => DuaryInfoRes.fromJson(p0)).data;
  }
}