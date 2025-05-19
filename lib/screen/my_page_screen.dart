import 'package:duary/model/couple.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/screen/edit_birthday_screen.dart';
import 'package:duary/screen/edit_name_screen.dart';
import 'package:duary/screen/login_screen.dart';
import 'package:duary/widget/button_base.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/characters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  DuaryContext duaryContext = DuaryContext();

  late Member me;

  late Couple myCouple;

  late final void Function() listener;

  @override
  void initState() {
    me = duaryContext.me.value!;
    listener = () {
      if (duaryContext.me.value != null) {
        setState(() {
          me = duaryContext.me.value!;
        });
      }
      return;
    };
    duaryContext.me.addListener(listener);
    myCouple = duaryContext.myCouple.value!;
    super.initState();
  }

  String formatDateTime(DateTime req) => DateFormat('yy.MM.dd').format(req);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBase(
        appBarObj: AppBar(),
        leadingBuilder: (context) => ButtonBase(
            onTap: () async {
              Navigator.pop(context);
            },
            child: const Icon(Icons.navigate_before)),
        centerBuilder: (context) => const Text(
          "마이페이지",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFFFE8F00),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  children: [
                    // TODO: 아이콘 변경
                    const Yellow(
                      width: 85,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Container(
                        width: 248,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x555555).withOpacity(0.06),
                              offset: const Offset(0, 2),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${me.name}, 좋은 하루애오!",
                                style: const TextStyle(
                                  color: Color(0xFF434343),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              const SectionTitle(text: "알림 설정"),
              const SizedBox(
                height: 8,
              ),
              // TODO: 일정 알림 설정값
              ButtonBase(
                  onTap: () async {},
                  child: infoBox(labelText: "내 일정 알림", currentValue: "30분 전")),
              const SizedBox(
                height: 10,
              ),
              ButtonBase(
                  onTap: () async {},
                  child: infoBox(labelText: "연인 일정 알림", currentValue: "30분 전")),
              const SizedBox(
                height: 27,
              ),
              const SectionTitle(text: "내 정보"),
              const SizedBox(
                height: 8,
              ),
              ButtonBase(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditNameScreen()));
                  },
                  child: infoBox(labelText: "닉네임", currentValue: me.name!)),
              const SizedBox(
                height: 10,
              ),
              ButtonBase(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditBirthdayScreen()));
                  },
                  child: infoBox(
                      labelText: "생일",
                      currentValue: formatDateTime(me.birthday!))),
              const SizedBox(
                height: 27,
              ),
              const SectionTitle(text: "커플 정보"),
              const SizedBox(
                height: 8,
              ),
              ButtonBase(
                  onTap: () async {},
                  child: infoBox(
                      labelText: "사랑이 시작된 날",
                      currentValue: formatDateTime(myCouple.relationDate))),
              const SizedBox(
                height: 56,
              ),
              Align(
                alignment: Alignment.center,
                child: ButtonBase(
                  onTap: () async {
                    await DuaryContext().signOut().then((_) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (p) => false);
                    });
                  },
                  child: const Text(
                    "로그아웃",
                    style: TextStyle(
                      color: Color(0xFFFF0000),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container infoBox({
    required String labelText,
    required String currentValue,
  }) {
    return Container(
      width: double.infinity,
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
            Row(
              children: [
                Text(
                  currentValue,
                  style: const TextStyle(
                    color: Color(0xFFB6B6B6),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFB6B6B6),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    duaryContext.me.removeListener(listener);
    super.dispose();
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF323232),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
