import 'package:duary/data/authorization_token_res.dart';
import 'package:duary/data/duary_info_res.dart';
import 'package:duary/data/dummy_sign_in_req.dart';
import 'package:duary/data/sign_in_req.dart';

abstract interface class AuthRepository {

  Future<DuaryInfoRes> signInWithToken(SignInReq req);

  Future<AuthorizationTokenRes> reissue(String accessToken, String refreshToken);

  Future<DuaryInfoRes> signInWithKakaoTalk(SignInReq req);

  Future<DuaryInfoRes> signInWithApple(SignInReq req);

  Future<DuaryInfoRes> signInWithGoogle(SignInReq req);

  Future<DuaryInfoRes> dummySignIn(DummySignInReq req);

  Future<void> signOut();

  Future<void> withdrawal();

}