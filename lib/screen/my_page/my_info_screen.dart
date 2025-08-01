import 'package:duary/provider/duary_context.dart';
import 'package:duary/screen/login_screen.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/button_base.dart';
import 'package:duary/widget/duary_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyInfoScreen extends StatelessWidget {
  const MyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DuaryContext duaryContext = DuaryContext();
    return Scaffold(
      appBar: SubPageAppBar(appBarObj: AppBar(), title: const SubPageTitle(title: "내 정보")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
