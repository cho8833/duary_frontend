import 'package:duary/provider/auth_provider.dart';
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
                    onClick: () {
                      authProvider.signInWithKakaoTalk().catchError((e) {
                        Fluttertoast.showToast(msg: e.toString());
                      });
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
                  const SizedBox(height: 48,)
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
