import 'package:duary/data/authorization_token_res.dart';
import 'package:duary/data/sign_in_req.dart';
import 'package:duary/data/sign_up_req.dart';
import 'package:duary/model/member.dart';

abstract interface class AuthRepository {

  Future<AuthorizationTokenRes> signIn({SignInReq? req});

  Future<Member> getUserInfo();

  Future<AuthorizationTokenRes> reissue(String accessToken, String refreshToken);

  Future<AuthorizationTokenRes> signUp(SignUpReq req);
}