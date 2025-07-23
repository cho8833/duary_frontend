import 'package:duary/provider/duary_context.dart';
import 'package:duary/screen/start/connect_copule_screen.dart';
import 'package:duary/screen/home_screen.dart';
import 'package:duary/screen/start/start_duary_screen.dart';
import 'package:duary/support/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final DuaryContext duaryContext = DuaryContext();

  //test var
  String? username;

  void onSignInComplete() {
    if (duaryContext.isCoupleCreated()) {
      if (duaryContext.isCoupleConnected()) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
                (p) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const ConnectCoupleScreen()),
                (p) => false);
      }
    }
    // 커플이 생성되어 있지 않으면 StartDuaryScreen 으로 route
    else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const StartDuaryScreen()),
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
                    await duaryContext.signInWithKakaoTalk().then((_) {
                      onSignInComplete();
                    }).catchError((e) {
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
                    duaryContext.signInWithApple().then((_) {
                      onSignInComplete();
                    }).catchError((e) {
                      Fluttertoast.showToast(msg: e.toString());
                    });
                  },
                ),
                const SizedBox(
                  height: 48,
                ),
                //test~
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 48,
                      child: TextField(
                        onSubmitted: (value) {
                          if (value != null || value.isEmpty == false) {
                            username = value;
                          } else {
                            username = null;
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (username == null) {
                          Fluttertoast.showToast(msg: 'id를 입력해주세요');
                        } else {
                          await duaryContext.dummySignIn(username!).then((_) {
                            onSignInComplete();
                          }).catchError((e) {
                            Fluttertoast.showToast(msg: e.toString());
                          });
                        }
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 48,
                )
                //~test
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
