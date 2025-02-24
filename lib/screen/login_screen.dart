import 'package:duary/provider/auth_provider.dart';
import 'package:duary/screen/home_screen.dart';
import 'package:duary/screen/input_couple_info_screen.dart';
import 'package:duary/support/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthProvider authProvider;

  @override
  void initState() {
    authProvider = AuthProvider();
    super.initState();
  }

  void onSignInComplete(bool? isRegister) {
    // 회원가입 성공 시 커플 정보 입력화면으로 이동
    if (isRegister == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const InputCoupleInfoScreen()),
          (p) => false);
    }
    // 회원가입된 회원이면 홈화면으로 이동
    else if (isRegister == false) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (p) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(48, 0, 48, 0),
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(AssetPath.duarySplashLogo),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ButtonShadow(
                  button: Image.asset(
                    AssetPath.kakaoLogin,
                    width: double.infinity,
                  ),
                  onClick: () async {
                    bool? isRegister = await authProvider
                        .signInWithKakaoTalk()
                        .catchError((e) {
                      Fluttertoast.showToast(msg: e.toString());
                      return null;
                    });
                    onSignInComplete(isRegister);
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                _ButtonShadow(
                  button: Image.asset(
                    AssetPath.appleLogin,
                    width: double.infinity,
                  ),
                  onClick: () {
                    authProvider.signInWithApple();
                  },
                ),
                const SizedBox(
                  height: 48,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonShadow extends StatelessWidget {
  const _ButtonShadow({required this.button, required this.onClick});

  final Widget button;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
            color: Colors.black.withOpacity(0.1))
      ]),
      child: GestureDetector(onTap: onClick, child: button),
    );
  }
}
