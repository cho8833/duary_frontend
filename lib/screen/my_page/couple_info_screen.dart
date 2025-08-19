import 'package:duary/provider/duary_context.dart';
import 'package:duary/screen/my_page/my_info_screen.dart';
import 'package:duary/screen/start/connect_copule_screen.dart';
import 'package:duary/screen/start/start_duary_screen.dart';
import 'package:duary/support/custom_page_route.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/button_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:fluttertoast/fluttertoast.dart';

class CoupleInfoScreen extends StatelessWidget {
  const CoupleInfoScreen({super.key});

  static const String codeMent =
      "커플 코드는 추후 다시 커플에 연결하거나,\n커플 정보를 복원할 때 사용될 수 있습니다.\n잃어버리지 않도록 안전한 곳에 저장해주세요.";

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
            duaryContext.isCoupleConnected()
                ? Container()
                : GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          SlideDownRoute(page: const ConnectCoupleScreen()));
                    },
                    child: const InfoBox(
                        labelText: "커플 연결하기", value: Icon(Icons.chevron_right)),
                  ),
            const SizedBox(
              height: 16,
            ),
            FutureButton(
              onTap: () async {
                Clipboard.setData(
                        ClipboardData(text: duaryContext.myCouple.value!.code))
                    .then((_) {
                  Fluttertoast.showToast(msg: "복사되었습니다");
                });
              },
              child: InfoBox(
                  labelText: "커플 코드",
                  value: Row(
                    children: [
                      Text(duaryContext.myCouple.value!.code),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(Icons.copy),
                    ],
                  )),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              codeMent,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFBBBBBB),
                  fontWeight: FontWeight.w500),
            ),
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
              child: duaryContext.isCoupleConnected()
                  ? const Text(
                      "커플 연결 끊기",
                      style: TextStyle(
                        color: Color(0xFFFF0000),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Container(),
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
