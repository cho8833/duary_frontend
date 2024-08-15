import 'package:duary/support/asset_path.dart';
import 'package:duary/support/button_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConnectCoupleScreen extends StatefulWidget {
  const ConnectCoupleScreen({super.key});

  @override
  State<ConnectCoupleScreen> createState() => _ConnectCoupleScreenState();
}

class _ConnectCoupleScreenState extends State<ConnectCoupleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 48,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      AssetPath.duaryLogo,
                      height: 48,
                    ),
                    const Positioned(
                        right: 0,
                        child: Icon(Icons.close, color: Color(0xFF9A9A9A))),
                  ],
                ),
              ),
              const SizedBox(
                height: 64,
              ),
              const Text(
                "커플 연결 후\n우리만의 다이어리를 열어보세요.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "NanumSquareRound",
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF464646),
                    fontSize: 18),
              ),
              const SizedBox(
                height: 56,
              ),
              Image.asset(
                AssetPath.duarySet,
                width: 136,
                height: 168,
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "나의 코드 복사",
                style: TextStyle(
                  fontFamily: "NanumSquareRound",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFF464646),
                ),
              ),
              const Text(
                "hbge4frvr",
                style: TextStyle(
                    fontFamily: "NanumSquareRound",
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF464646),
                    decoration: TextDecoration.underline),
              ),
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(48, 0, 48, 0),
                child: Column(
                  children: [
                    ButtonBase(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFFffbd64)),
                          child: const Text(
                            "초대장 보내기",
                            style: TextStyle(
                                fontFamily: "NanumSquareRound",
                                color: Color(0xFF573200),
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(child: Divider()),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            'or',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "NanumSquareRound",
                                color: Color(0xFF9A9A9A),
                                fontSize: 16),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ButtonBase(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: const Color(0xFFFFbd64), width: 2)),
                          child: const Text(
                            "상대방 코드로 연결하기",
                            style: TextStyle(
                                fontFamily: "NanumSquareRound",
                                color: Color(0xFF573200),
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
