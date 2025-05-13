import 'dart:convert';
import 'package:duary/screen/connect_copule_screen.dart';
import 'package:duary/screen/home_screen.dart';
import 'package:duary/support/http_request_interceptor.dart';
import 'package:duary/support/uri_provider.dart';
import 'package:duary/widget/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:duary/repository/impl/couple_repository_impl.dart';
import 'package:duary/provider/duary_context.dart';

class InputCodeScreen extends StatefulWidget {
  const InputCodeScreen({super.key});

  @override
  State<InputCodeScreen> createState() => _InputCodeScreenState();
}

class _InputCodeScreenState extends State<InputCodeScreen> {
  final DuaryContext duaryContext = DuaryContext();
  String coupleCode = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XffFFFFFF),
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar(
        appBarObj: AppBar(),
        leadingBuilder: (context) => GestureDetector(
          onTap: () {
            Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConnectCoupleScreen(),
                ));
          },
          child: const Icon(Icons.chevron_left),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 66,
              ),
              const Text(
                textAlign: TextAlign.center,
                "우리의 커플 코드를 입력해주세요.",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "NanumSquareRound",
                  fontWeight: FontWeight.w700,
                  color: Color(0Xff464646),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                width: double.infinity,
                height: 32,
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  onChanged: (value) {
                    coupleCode = value;
                  },
                  cursorColor: const Color(0XffE3DDD7),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0Xff464646),
                      fontFamily: "Pretendard",
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    hintText: "코드 입력",
                    hintStyle: TextStyle(
                      color: Color(0XffE3DDD7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color(0XffE3DDD7),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color(0XffE3DDD7),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: GestureDetector(
                  onTap: () async {
                    if (coupleCode.isEmpty == true) {
                      Fluttertoast.showToast(msg: "코드를 입력해주세요");
                    } else {
                      await duaryContext.inputCoupleCode(coupleCode).then((_) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                              );
                      }).catchError((e) {
                        Fluttertoast.showToast(msg: e.toString());
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0XffFFBD64),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "연결하기",
                        style: TextStyle(
                          fontFamily: "NanumSquareRound",
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0Xff573200),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 144,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
