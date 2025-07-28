import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInReq {
  OAuthToken? kakaoOAuthToken;
  AuthorizationCredentialAppleID? appleOAuthToken;
  GoogleSignInAccount? googleOAuthToken;
  String? fcmToken;

  SignInReq({this.kakaoOAuthToken, this.appleOAuthToken, this.fcmToken, this.googleOAuthToken});

  Map<String , dynamic> toJson() {
    return {
      "kakaoOAuthToken": kakaoOAuthToken?.toJson(),
      "appleOAuthToken": appleOAuthToken?.toJson(),
      "googleOAuthToken": googleOAuthToken?.toJson(),
      "fcmToken": fcmToken
    };
  }
}

extension ToJsonGoogleSignInAccount on GoogleSignInAccount {
  Map<String, dynamic> toJson() {
    return {
      "displayName": displayName,
      "email": email,
      "id": id,
      "photoUrl": photoUrl,
      "idToken": authentication.idToken
    };
  }
}


extension ToJsonApple on AuthorizationCredentialAppleID {
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