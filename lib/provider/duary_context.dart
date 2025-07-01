import 'package:duary/data/duary_info_res.dart';
import 'package:duary/data/dummy_sign_in_req.dart';
import 'package:duary/data/sign_in_req.dart';
import 'package:duary/data/start_duary_req.dart';
import 'package:duary/data/input_couple_code_req.dart';
import 'package:duary/data/update_couple_req.dart';
import 'package:duary/data/update_member_req.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/model/enums/character.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/token_provider.dart';
import 'package:duary/repository/auth_repository.dart';
import 'package:duary/repository/couple_repository.dart';
import 'package:duary/repository/member_repository.dart';
import 'package:duary/support/custom_exception.dart';
import 'package:duary/support/secret_key.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class DuaryContext {
  // singleton
  static final DuaryContext _instance = DuaryContext._internal();

  factory DuaryContext() => _instance;

  DuaryContext._internal();

  static const String nonce = SecretKey.oidcNonce;

  late final CoupleRepository _coupleRepository;

  late final AuthRepository _authRepository;

  late final MemberRepository _memberRepository;

  void init(CoupleRepository coupleRepository, AuthRepository authRepository,
      MemberRepository memberRepository) {
    _coupleRepository = coupleRepository;
    _authRepository = authRepository;
    _memberRepository = memberRepository;
  }

  final TokenProvider tokenProvider = TokenProvider();

  ValueNotifier<Couple?> myCouple = ValueNotifier(null);

  ValueNotifier<Member?> me = ValueNotifier(null);

  ValueNotifier<Member?> lover = ValueNotifier(null);

  Future<void> signInWithApple() async {
    late final AuthorizationCredentialAppleID credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
      ], nonce: nonce);
    } catch (e) {
      if (e is SignInWithAppleAuthorizationException) {
        if (e.code == AuthorizationErrorCode.canceled) {
          throw CustomException("취소되었습니다");
        }
      }
    }
    final String? fcmToken = await _requestFcmToken();
    SignInReq req = SignInReq(appleOAuthToken: credential, fcmToken: fcmToken);
    await _authRepository.signInWithApple(req).then((res) async {
      onSignInSuccess(res);
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  Future<void> signInWithKakaoTalk() async {
    late OAuthToken token;
    try {
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk(nonce: nonce);
      } else {
        token = await UserApi.instance.loginWithKakaoAccount(nonce: nonce);
      }
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == "CANCELED") {
          throw CustomException("취소되었습니다");
        }
      }
    }
    final String? fcmToken = await _requestFcmToken();
    SignInReq req = SignInReq(kakaoOAuthToken: token, fcmToken: fcmToken);
    await _authRepository.signInWithKakaoTalk(req).then((res) async {
      onSignInSuccess(res);
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  Future<void> signInWithToken() async {
    final String? fcmToken = await _requestFcmToken();
    SignInReq req = SignInReq(fcmToken: fcmToken);
    await _authRepository.signInWithToken(req).then((res) {
      onSignInSuccess(res);
    }).catchError((e) {});
  }

  Future<void> dummySignIn(String username) async {
    final String? fcmToken = await _requestFcmToken();
    DummySignInReq req = DummySignInReq(username, fcmToken: fcmToken);
    await _authRepository.dummySignIn(req).then((res) async {
      onSignInSuccess(res);
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  Future<String?> _requestFcmToken() async {
    final String? fcmToken =
        await FirebaseMessaging.instance.getToken().catchError((e) {
      return null;
    });
    return fcmToken;
  }

  void onSignInSuccess(DuaryInfoRes res) {
    me.value = res.member;
    myCouple.value = res.couple;
    if (res.couple != null) {
      lover.value = getLoverFromCouple(res.couple!);
    }
  }

  Future<void> signOut() async {
    await tokenProvider.deleteToken();
    await _authRepository.signOut();
    me.value = null;
  }

  Future<void> getMyCouple() async {
    await _coupleRepository.getMyCouple().then((couple) {
      myCouple.value = couple;
      lover.value = getLoverFromCouple(couple);
    });
  }

  Future<void> startDuary(
    String? name,
    DateTime? birthday,
    DateTime? relationDate,
    Character myCharacter,
  ) async {
    validateName(name);
    validateBirthday(birthday);
    validateRelationDate(relationDate);
    DateTime birthdayReq =
        DateTime(birthday!.year, birthday.month, birthday.day);
    DateTime relationDateReq =
        DateTime(relationDate!.year, relationDate.month, relationDate.day);
    StartDuaryReq req =
        StartDuaryReq(name!, birthdayReq, relationDateReq, myCharacter);
    await _coupleRepository.startDuary(req).then((res) {
      me.value = res.member;
      myCouple.value = res.couple;
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  Future<void> inputCoupleCode(String coupleCode) async {
    InputCoupleCodeReq req = InputCoupleCodeReq(coupleCode);
    await _coupleRepository.inputCoupleCode(req).then((res) {
      me.value = res.member;
      myCouple.value = res.couple;
      lover.value = getLoverFromCouple(res.couple);
    }).catchError((e) {
      throw ServerResponseException(e.toString());
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

  Member? getLoverFromCouple(Couple couple) {
    Member? lover;
    if (myCouple.value!.members.length > 1) {
      lover = myCouple.value!.members
          .firstWhere((m) => m.socialId != me.value!.socialId);
    }
    return lover;
  }

  void validateName(String? name) {
    if (name == null || name.isEmpty == true) {
      throw ValidationException("닉네임을 입력해주세요");
    }
  }

  void validateBirthday(DateTime? birthday) {
    DateTime now = DateTime.now();
    if (birthday == null) {
      throw ValidationException("생일을 입력해주세요");
    }
    if (birthday.isAfter(now)) {
      throw ValidationException("생일을 다시 설정해주세요");
    }
  }

  void validateRelationDate(DateTime? relationDate) {
    DateTime now = DateTime.now();
    if (relationDate == null) {
      throw ValidationException("처음 만난 날을 입력해주세요");
    }
    if (relationDate.isAfter(now)) {
      throw ValidationException("생일을 다시 설정해주세요");
    }
  }

  Future<void> updateMember({String? name, DateTime? birthday}) async {
    if (name != null) {
      validateName(name);
    }
    if (birthday != null) {
      validateBirthday(birthday);
    }

    UpdateMemberReq req = UpdateMemberReq(name, birthday);
    await _memberRepository.updateMember(req).then((res) {
      me.value = res.member;
      myCouple.value = res.couple;
    }).catchError((e) {
      throw ServerResponseException(e);
    });
  }

  Future<void> updateCouple({DateTime? relationDate}) async {
    validateRelationDate(relationDate);
    UpdateCoupleReq req = UpdateCoupleReq(relationDate!);
    await _coupleRepository.updateCouple(req).then((couple) {
      myCouple.value = couple;
    });
  }
}
