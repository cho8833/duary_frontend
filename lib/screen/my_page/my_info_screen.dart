import 'package:duary/model/enums/social_provider.dart';
import 'package:duary/provider/auth_provider.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/screen/login_screen.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/button_base.dart';
import 'package:duary/widget/duary_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class MyInfoScreen extends StatelessWidget {
  const MyInfoScreen({super.key});

  String formatDateTime(DateTime req) => DateFormat('yy.MM.dd').format(req);

  @override
  Widget build(BuildContext context) {
    final DuaryContext duaryContext = DuaryContext();
    final SocialProvider socialProvider =
        SocialProvider.fromString(duaryContext.me.value!.provider);
    return Scaffold(
      appBar: SubPageAppBar(
          appBarObj: AppBar(), title: const SubPageTitle(title: "내 정보")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InfoBox(
                labelText: "로그인 방법",
                value: Row(
                  children: [
                    Image.asset(socialProvider.iconPath, width: 24, height: 24,),
                    _ValueText(currentValue: socialProvider.title),
                  ],
                )),
            const SizedBox(
              height: 8,
            ),
            InfoBox(
                labelText: "이름",
                value: _ValueText(
                  currentValue: duaryContext.me.value!.name!,
                )),
            const SizedBox(
              height: 8,
            ),
            InfoBox(
                labelText: "생일",
                value: _ValueText(
                    currentValue:
                        formatDateTime(duaryContext.me.value!.birthday!))),
            const Spacer(),
            Center(
              child: FutureButton(
                onTap: () async {
                  duaryContext.withdrawal().then((_) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (p) => false);
                  }).catchError((e) {
                    Fluttertoast.showToast(msg: e.toString());
                  });
                },
                child: const Text(
                  "회원 탈퇴",
                  style: TextStyle(
                    color: Color(0xFFFF0000),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({super.key, required this.labelText, required this.value});

  final String labelText;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              labelText,
              style: const TextStyle(
                color: Color(0xFF000000),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            value
          ],
        ),
      ),
    );
  }
}

class _ValueText extends StatelessWidget {
  const _ValueText({super.key, required this.currentValue});

  final String currentValue;

  @override
  Widget build(BuildContext context) {
    return Text(
      currentValue,
      style: const TextStyle(
        color: Color(0xFFB6B6B6),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
