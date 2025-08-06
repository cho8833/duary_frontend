import 'package:duary/support/asset_path.dart';

enum SocialProvider {
  google("google", "구글 로그인", AssetPath.googleIcon),
  apple("apple", "애플 로그인", AssetPath.appleIcon),
  kakao("kakao", "카카오 로그인", AssetPath.kakaoIcon);

  final String value;

  final String title;

  final String iconPath;

  const SocialProvider(this.value, this.title, this.iconPath);

  factory SocialProvider.fromString(String v) =>
      SocialProvider.values.firstWhere((p) => p.value == v);
}
