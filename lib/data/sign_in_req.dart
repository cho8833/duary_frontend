import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInReq {
  OAuthToken? kakaoOAuthToken;
  AuthorizationCredentialAppleID? appleOAuthToken;
  String? fcmToken;

  SignInReq({this.kakaoOAuthToken, this.appleOAuthToken, this.fcmToken});

  Map<String , dynamic> toJson() {
    return {
      "kakaoOAuthToken": kakaoOAuthToken?.toJson(),
      "appleOAuthToken": appleOAuthToken?.toJson(),
      "fcmToken": fcmToken
    };
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