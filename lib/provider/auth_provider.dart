
import 'package:duary/data/dummy_sign_in_req.dart';
import 'package:duary/data/sign_in_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/token_provider.dart';
import 'package:duary/repository/auth_repository.dart';
import 'package:duary/support/custom_exception.dart';
import 'package:flutter/services.dart';

class AuthProvider {
  // singleton
  static final AuthProvider _instance = AuthProvider._internal();
  factory AuthProvider() => _instance;
  AuthProvider._internal();

  void init(AuthRepository authRepository) {
    _repository = authRepository;
  }

  late final AuthRepository _repository;
  final TokenProvider tokenProvider = TokenProvider();

  ValueNotifier<bool> isLoggedIn = ValueNotifier(false);

  String? errorMessage;

  Member? me;

  Future<void> signInWithApple() async {
    await _repository.signInWithApple();
  }

  Member onSignInSuccess(SignInRes res)  {
     me = res.member;
     return me!;
  }

  Future<Member> signInWithKakaoTalk() async {
    return await _repository.signInWithKakaoTalk().then((res) async {
      // http intercepter 에서 token 관련 처리해줌
      // await tokenProvider.storeAccessToken(res.accessToken);
      // await tokenProvider.storeRefreshToken(res.refreshToken);
      return onSignInSuccess(res);
    }).catchError((e) {
      if (e is PlatformException) {
        if (e.code == "CANCELED") {
          throw CustomException("취소되었습니다");
        }
      }
      throw ServerResponseException(e.toString());
    });
  }

  Future<void> signOut() async {
    await tokenProvider.deleteToken();
    me = null;
    isLoggedIn.value = false;
  }

  Future<void> checkSignIn() async {
    await _repository.getUserInfo().then((user) {
      me = user;
      isLoggedIn.value = true;
    }).catchError((e) {
      print(e);
    });
  }

  String? validateSignUp(String username, String password) {
    if (username.isEmpty) {
      return "username 을 입력해주세요";
    }
    if (password.isEmpty) {
      return "password 를 입력해주세요";
    }
    return null;
  }

  Future<Member> dummySignIn(int username) async {
    DummySignInReq req = DummySignInReq(username);

    return await _repository.dummySignIn(req).then((res) async {
      // http intercepter 에서 token 관련 처리해줌
      // await tokenProvider.storeAccessToken(res.accessToken);
      // await tokenProvider.storeRefreshToken(res.refreshToken);
      return onSignInSuccess(res);
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }
}