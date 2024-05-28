import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duary/data/sign_in_req.dart';
import 'package:duary/data/sign_up_req.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/token_provider.dart';
import 'package:duary/repository/auth_repository.dart';
import 'package:duary/support/custom_exception.dart';

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

  Future<void> signInIdPw(String username, String password) async {
    SignInReq req = SignInReq(username, password);
    await _repository.signIn(req: req).then((res) async {
      await tokenProvider.storeAccessToken(res.accessToken);
      await tokenProvider.storeRefreshToken(res.refreshToken);
      await _repository.getUserInfo().then((user) {
        me = user;
      });
      isLoggedIn.value = true;
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  Future<void> signUp(String username, String password) async {
    String? validate = validateSignUp(username, password);
    if (validate != null) {
      throw ServerResponseException(validate);
    }
    SignUpReq req = SignUpReq(username, password);
    await _repository.signUp(req).then((token) async {
      await tokenProvider.storeAccessToken(token.accessToken);
      await tokenProvider.storeRefreshToken(token.refreshToken);
      await _repository.getUserInfo().then((user) {
        me = user;
      });
      isLoggedIn.value = true;
    }).catchError((e) {
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
    }).catchError((e) {});
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

}