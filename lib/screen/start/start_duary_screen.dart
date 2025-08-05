import 'package:duary/model/enums/character.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/screen/home_screen.dart';
import 'package:duary/screen/start/connect_copule_screen.dart';
import 'package:duary/screen/login_screen.dart';
import 'package:duary/support/custom_page_route.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/button_base.dart';
import 'package:duary/widget/character_widget.dart';
import 'package:duary/widget/duary_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StartDuaryScreen extends StatefulWidget {
  const StartDuaryScreen({super.key});

  @override
  State<StartDuaryScreen> createState() => _StartDuaryScreenState();
}

class _StartDuaryScreenState extends State<StartDuaryScreen> {
  final DuaryContext duaryContext = DuaryContext();

  String? name;

  DateTime? birthday;

  DateTime? relationDate;

  bool blue = true;

  late Character myCharacter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar(appBarObj: AppBar()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 48,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 58,
              ),
              const Column(
                children: [
                  Text(
                    '만나서 반가워요!',
                    style: TextStyle(
                      color: Color(0xFFFF9000),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    '우리의 시작을 알려주세요.',
                    style: TextStyle(
                      color: Color(0xFF6E6E6E),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              DuaryTextInputBox(
                onChange: (value) {
                  name = value;
                },
                hintText: "내 이름 / 닉네임",
              ),
              const SizedBox(
                height: 18,
              ),
              DuaryDateInputBox(
                onSelect: (value) {
                  birthday = value;
                },
                hintText: "내 생년월일",
                futureDateSelectable: false,
              ),
              const SizedBox(
                height: 18,
              ),
              DuaryDateInputBox(
                onSelect: (value) {
                  relationDate = value;
                },
                hintText: "우리가 처음 만난 날",
                futureDateSelectable: false,
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureButton(
                    onTap: () async {
                      setState(() {
                        blue ? blue = false : blue = true;
                      });
                    },
                    child: const Icon(
                      Icons.chevron_left,
                      color: Color(0xFF5D5D5D),
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  whichCharacter(),
                  const SizedBox(
                    width: 40,
                  ),
                  FutureButton(
                    onTap: () async {
                      setState(() {
                        blue ? blue = false : blue = true;
                      });
                    },
                    child: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF5D5D5D),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '내 캐릭터',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              FutureButton(
                onTap: () async {
                  blue
                      ? myCharacter = Character.blue
                      : myCharacter = Character.yellow;

                  await duaryContext
                      .startDuary(name, birthday, relationDate, myCharacter)
                      .then((_) async {
                    await Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                            (p) => false);
                    Navigator.of(context).push(
                        SlideDownRoute(page: const ConnectCoupleScreen()));
                  }).catchError((e) {
                    Fluttertoast.showToast(msg: e.toString());
                  });
                },
                child: Container(
                  width: 400,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFBD64),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                      child: Text(
                        'Duary 시작하기',
                        style: TextStyle(
                          color: Color(0xFF573200),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              FutureButton(
                  onTap: () async {
                    duaryContext.signOut().then((_) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                              (p) => false);
                    });
                  },
                  child: const Text(
                    "다른 계정으로 로그인",
                    style: TextStyle(fontSize: 13),
                  )),
              const SizedBox(
                height: 16,
              ),
              const Text(
                '위 내용은 연결된 상대방의 Duary에도 보이며\n'
                    '마이페이지에서 변경 가능합니다. 입력하신\n'
                    '모든 정보는 서비스 최적화를 위해서만 사용됩니다.',
                style: TextStyle(
                  color: Color(0xFFCBCBCB),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox whichCharacter() {
    if (blue) {
      return characterBlue();
    } else {
      return characterYellow();
    }
  }

  SizedBox characterBlue() {
    return SizedBox(
      width: 60,
      height: 103,
      child: GestureDetector(
        onTap: () {
          setState(() {
            blue = false;
          });
        },
        child: const Blue(),
      ),
    );
  }

  SizedBox characterYellow() {
    return SizedBox(
      width: 60,
      height: 103,
      child: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              blue = true;
            });
          },
          child: const Yellow(),
        ),
      ),
    );
  }
}
