import 'dart:convert';
import 'package:duary/data/dummy_sign_in_req.dart';
import 'package:duary/data/sign_in_res.dart';
import 'package:duary/support/secret_key.dart';
import 'package:http/http.dart';
import 'package:duary/data/authorization_token_res.dart';
import 'package:duary/data/sign_in_req.dart';
import 'package:duary/data/sign_up_req.dart';
import 'package:duary/model/member.dart';
import 'package:duary/repository/auth_repository.dart';
import 'package:duary/support/http_response_handler.dart';
import 'package:duary/support/uri_provider.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final class AuthRepositoryImpl
    with HttpResponseHandler, UriProvider
    implements AuthRepository {
  AuthRepositoryImpl(this.client, this.interceptedClient);

  final Client interceptedClient;

  final Client client;

  static const String nonce =
      SecretKey.oidcNonce;

  @override
  Future<SignInRes> signInWithKakaoTalk() async {
    late OAuthToken token;
    if (await isKakaoTalkInstalled()) {
      token = await UserApi.instance.loginWithKakaoTalk(nonce: nonce);
    } else {
      token = await UserApi.instance.loginWithKakaoAccount(nonce: nonce);
    }

    Uri uri = getUri("/auth/signin/kakao");

    Response response =
        await client.post(uri, body: jsonEncode(token.toJson()));

    return getData(response, (p0) => SignInRes.fromJson(p0)).data;
  }

  @override
  Future<SignInRes> signInWithApple() async {
    final AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
    ], nonce: nonce);

    Uri uri = getUri("/auth/signin/apple");
    
    Response response = await client.post(uri, body: jsonEncode(credential.toJson()));

    return getData(response, (p) => SignInRes.fromJson(p)).data;
  }

  @override
  Future<AuthorizationTokenRes> signInWithIdPw({SignInReq? req}) async {
    Uri uri = getUri("/auth/signIn/idpw");

    Response response = await client.post(uri, body: jsonEncode(req?.toJson()));

    return getData(response, (p0) => AuthorizationTokenRes.fromJson(p0)).data;
  }

  @override
  Future<Member> getUserInfo() async {
    Uri uri = getUri("/member/me");

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

  @override
  Future<SignInRes> dummySignIn(DummySignInReq req) async {
    Uri uri = getUri("/auth/signin/dummy");

    Response response = await client.post(uri, body: jsonEncode(req.toJson()));

    return getData(response, (p0) => SignInRes.fromJson(p0)).data;
  }
}

extension ToJson on AuthorizationCredentialAppleID {
  Map<String, dynamic> toJson() {
    return {
      "userIdentifier": userIdentifier,
      "givenName": givenName,
      "familyName": familyName,
      "authorizationCode": authorizationCode,
      "email": email,
      "identityToken": identityToken,
      "state": state
    };
  }
}