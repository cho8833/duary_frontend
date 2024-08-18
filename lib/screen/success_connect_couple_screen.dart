import 'package:duary/widget/main_app_bar.dart';
import 'package:flutter/material.dart';

class SuccessConnectCoupleScreen extends StatefulWidget {
  const SuccessConnectCoupleScreen({super.key});

  @override
  State<SuccessConnectCoupleScreen> createState() =>
      _SuccessConnectCoupleScreenState();
}

class _SuccessConnectCoupleScreenState
    extends State<SuccessConnectCoupleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBarObj: AppBar(),
        trailingBuilder: (context) => const Icon(Icons.close),
      ),
      body: const SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 56,
            ),
            Text(
              "커플 연결 성공!",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFF9000)),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "우리의 시작을 알려주세요.",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6E6E6E)),
            ),
            SizedBox(
              height: 40,
            ),

          ],
        ),
      ),
    );
  }
}
