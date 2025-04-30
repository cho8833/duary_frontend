import 'dart:ffi';

import 'package:duary/data/sign_in_res.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/auth_provider.dart';
import 'package:duary/screen/home_screen.dart';
import 'package:duary/screen/input_couple_info_screen.dart';
import 'package:duary/support/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:duary/support/uri_provider.dart';
import 'package:http/http.dart';
import 'package:duary/support/http_response_handler.dart';
import 'package:duary/support/custom_exception.dart';
import 'dart:convert';
import 'package:duary/support/http_request_interceptor.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthProvider authProvider;

  //test var
  int? username = null;


  @override
  void initState() {
    authProvider = AuthProvider();
    super.initState();
  }

  void onSignInComplete(Member member) {
    // 회원가입 성공 시 커플 정보 입력화면으로 이동
    if (member.coupleId == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => InputCoupleInfoScreen()),
          (p) => false);
    }
    // 회원가입된 회원이면 홈화면으로 이동
    else {
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
                    Member member = await authProvider
                        .signInWithKakaoTalk()
                        .catchError((e) {
                      Fluttertoast.showToast(msg: e.toString());
                      return null;
                    });
                    onSignInComplete(member);
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
                ),
                //test~
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 240,
                      height: 48,
                      child: TextField(
                        onSubmitted: (value) {
                          if (value != null || value.isEmpty == false) {
                            username = int.parse(value);
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

                          Member member = await authProvider
                              .dummySignIn(username!)
                              .catchError((e) {
                            Fluttertoast.showToast(msg: e.toString());
                            return null;
                          });
                          onSignInComplete(member);
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
