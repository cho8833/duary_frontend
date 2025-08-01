import 'package:duary/provider/duary_context.dart';
import 'package:duary/screen/start/start_duary_screen.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/button_base.dart';
import 'package:duary/widget/duary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:fluttertoast/fluttertoast.dart';

class CoupleInfoScreen extends StatelessWidget {
  const CoupleInfoScreen({super.key});

  static const String codeMent =
      "커플 코드는 추후 다시 커플에 연결하거나 커플 정보를 복원할 때 사용될 수 있습니다. 잃어버리지 않도록 안전한 곳에 저장해주세요.";

  @override
  Widget build(BuildContext context) {
    final DuaryContext duaryContext = DuaryContext();

    return Scaffold(
      appBar: SubPageAppBar(
          appBarObj: AppBar(), title: const SubPageTitle(title: "커플 정보")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("커플 코드"),
                FutureButton(
                  onTap: () async {
                    Clipboard.setData(ClipboardData(
                        text: duaryContext.myCouple.value!.code))
                        .then((_) {
                      Fluttertoast.showToast(msg: "복사되었습니다");
                    });
                  },
                  child: Row(
                    children: [
                      Text(duaryContext.myCouple.value!.code),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(Icons.copy),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 8,),
            const Text(codeMent),
            const Spacer(),
            FutureButton(
              onTap: () async {
                duaryContext.disconnectCouple().then((_) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StartDuaryScreen()),
                      (p) => false);
                }).catchError((e) {
                  Fluttertoast.showToast(msg: e.toString());
                });
              },
              child: const Text(
                "커플 연결 끊기",
                style: TextStyle(
                  color: Color(0xFFFF0000),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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
