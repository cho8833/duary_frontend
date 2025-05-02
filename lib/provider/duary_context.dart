import 'package:duary/data/dummy_sign_in_req.dart';
import 'package:duary/data/sign_in_res.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/token_provider.dart';
import 'package:duary/repository/auth_repository.dart';
import 'package:duary/repository/couple_repository.dart';
import 'package:duary/support/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DuaryContext {

  // singleton
  static final DuaryContext _instance = DuaryContext._internal();
  factory DuaryContext() => _instance;
  DuaryContext._internal();

  late final CoupleRepository _coupleRepository;

  late final AuthRepository _authRepository;

  void init(CoupleRepository coupleRepository, AuthRepository authRepository) {
    _coupleRepository = coupleRepository;
    _authRepository = authRepository;
  }

  final TokenProvider tokenProvider = TokenProvider();

  ValueNotifier<Couple?> myCouple = ValueNotifier(null);

  ValueNotifier<Member?> me = ValueNotifier(null);

  ValueNotifier<Member?> lover = ValueNotifier(null);

  Member onSignInSuccess(SignInRes res)  {
    me.value = res.member;
    return me.value!;
  }

  Future<void> signInWithApple() async {
    await _authRepository.signInWithApple();
  }

  Future<void> signInWithKakaoTalk() async {
    await _authRepository.signInWithKakaoTalk().then((res) async {
      onSignInSuccess(res);
    }).catchError((e) {
      if (e is PlatformException) {
        if (e.code == "CANCELED") {
          throw CustomException("취소되었습니다");
        }
      }
      throw ServerResponseException(e.toString());
    });
  }

  Future<void> checkSignIn() async {
    await _authRepository.getUserInfo().then((user) {
      me.value = user;
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> dummySignIn(int username) async {
    DummySignInReq req = DummySignInReq(username);
    await _authRepository.dummySignIn(req).then((res) async {
      onSignInSuccess(res);
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  Future<void> signOut() async {
    await tokenProvider.deleteToken();
    me.value = null;
  }

  Future<void> getMyCouple() async {
    await _coupleRepository.getMyCouple().then((couple) {
      myCouple.value = couple;

      if (myCouple.value!.members.length > 1) {
        lover.value =
            myCouple.value!.members.firstWhere((m) => m.socialId != me.value!.socialId);
      }
    });
  }

  bool isLoggedIn() {
    return me.value != null;
  }

  bool isCoupleCreated() {
    return me.value != null && me.value!.coupleId != null;
  }

  bool isCoupleConnected() {
    return lover.value != null;
  }

}