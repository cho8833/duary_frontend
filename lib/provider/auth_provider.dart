import 'package:duary/data/dummy_sign_in_req.dart';
import 'package:duary/data/sign_in_req.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/support/custom_exception.dart';
import 'package:duary/support/secret_key.dart';
import 'package:firebase_messaging/firebase_messaging.dart' show FirebaseMessaging;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn, GoogleSignInException, GoogleSignInExceptionCode;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

extension AuthProvider on DuaryContext {

  static const String nonce = SecretKey.oidcNonce;

  Future<void> signInWithApple() async {
    AuthorizationCredentialAppleID? credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(nonce: nonce, scopes: [
        AppleIDAuthorizationScopes.fullName
      ]);
    } catch (e) {
      if (e is SignInWithAppleAuthorizationException) {
        if (e.code == AuthorizationErrorCode.canceled) {
          throw CustomException("취소되었습니다");
        }
      }
    }
    if (credential != null) {
      final String? fcmToken = await _requestFcmToken();
      SignInReq req = SignInReq(appleOAuthToken: credential, fcmToken: fcmToken);
      await authRepository.signInWithApple(req).then((res) async {
        res.member.name ??= credential!.givenName;
        refreshDuaryInfo(res);
      }).catchError((e) {
        throw ServerResponseException(e.toString());
      });
    }  else {
      throw CustomException("취소되었습니다");
    }
  }

  Future<void> signInWIthGoogle() async {
    if (GoogleSignIn.instance.supportsAuthenticate()) {
      await GoogleSignIn.instance.authenticate().then((account) async {
        final String? fcmToken = await _requestFcmToken();
        SignInReq req = SignInReq(googleOAuthToken: account, fcmToken: fcmToken);
        await authRepository.signInWithGoogle(req).then((res) async {
          res.member.name ??= account.displayName;
          refreshDuaryInfo(res);
        }).catchError((e) {
          throw ServerResponseException(e.toString());
        });
      }).catchError((e) {
        if (e is GoogleSignInException) {
          if (e.code == GoogleSignInExceptionCode.canceled) {
            throw CustomException("취소되었습니다");
          }
        }
        throw ServerResponseException(e.toString());
      });
    } else {
      throw CustomException("Google 로그인을 지원하지 않습니다");
    }
  }

  Future<void> signInWithToken() async {
    final String? fcmToken = await _requestFcmToken();
    SignInReq req = SignInReq(fcmToken: fcmToken);
    await authRepository.signInWithToken(req).then((res) {
      refreshDuaryInfo(res);
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> dummySignIn(String username) async {
    final String? fcmToken = await _requestFcmToken();
    DummySignInReq req = DummySignInReq(username, fcmToken: fcmToken);
    await authRepository.dummySignIn(req).then((res) async {
      refreshDuaryInfo(res);
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
    await authRepository.signInWithKakaoTalk(req).then((res) async {
      refreshDuaryInfo(res);
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

  Future<void> signOut() async {
    await tokenProvider.deleteToken();
    await authRepository.signOut();
    me.value = null;
    wsHandler.disconnect();
  }

  Future<void> withdrawal() async {
    await authRepository.withdrawal().then((_) async {
      await tokenProvider.deleteToken();
      me.value = null;
      wsHandler.disconnect();
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

}