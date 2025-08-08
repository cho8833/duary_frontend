import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/model/enums/alarm_offset.dart';
import 'package:duary/model/enums/character.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/auth_provider.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/screen/my_page/change_character_screen.dart';
import 'package:duary/screen/my_page/couple_info_screen.dart';
import 'package:duary/screen/my_page/edit_birthday_screen.dart';
import 'package:duary/screen/my_page/edit_name_screen.dart';
import 'package:duary/screen/login_screen.dart';
import 'package:duary/screen/my_page/edit_relation_date_screen.dart';
import 'package:duary/screen/my_page/my_info_screen.dart';
import 'package:duary/widget/button_base.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  late final void Function() meListener;
  late final void Function() coupleListener;

  @override
  void initState() {
    me = duaryContext.me.value!;
    myCouple = duaryContext.myCouple.value!;
    meListener = () {
      if (duaryContext.me.value != null) {
        setState(() {
          me = duaryContext.me.value!;
        });
      }
      return;
    };
    coupleListener = () {
      if (duaryContext.myCouple.value != null) {
        setState(() {
          myCouple = duaryContext.myCouple.value!;
        });
      }
    };
    duaryContext.me.addListener(meListener);
    duaryContext.myCouple.addListener(coupleListener);
    super.initState();
  }

  String formatDateTime(DateTime req) => DateFormat('yy.MM.dd').format(req);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBase(
        appBarObj: AppBar(),
        leadingBuilder: (context) => FutureButton(
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ChangeCharacterScreen()));
                      },
                      child: ClipOval(
                        child: Stack(
                          children: [
                            Character.characterCircleWidget(me.character!,
                                size: 85),
                            Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 85,
                                  height: 22,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFB4B4B4)
                                          .withAlpha(200)),
                                  child: const Center(
                                      child: Text(
                                    "바꾸기",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  )),
                                ))
                          ],
                        ),
                      ),
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyInfoScreen()));
                },
                child: const Row(
                  children: [
                    SectionTitle(text: "내 정보"),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditNameScreen()));
                  },
                  child: InfoBox(labelText: "닉네임", currentValue: me.name!)),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditBirthdayScreen()));
                  },
                  child: InfoBox(
                      labelText: "생일",
                      currentValue: formatDateTime(me.birthday!))),
              const SizedBox(
                height: 27,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CoupleInfoScreen()));
                },
                child: const Row(
                  children: [
                    SectionTitle(text: "커플 정보"),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FutureButton(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const EditRelationDateScreen()));
                  },
                  child: InfoBox(
                      labelText: "사랑이 시작된 날",
                      currentValue: formatDateTime(myCouple.relationDate))),
              const SizedBox(
                height: 56,
              ),
              Align(
                alignment: Alignment.center,
                child: FutureButton(
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
                      fontWeight: FontWeight.w600,
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

  @override
  void dispose() {
    duaryContext.me.removeListener(meListener);
    duaryContext.myCouple.removeListener(coupleListener);
    super.dispose();
  }
}

class AlarmOffsetDropdownButton extends StatefulWidget {
  const AlarmOffsetDropdownButton(
      {super.key,
      required this.initialValue,
      required this.onSelect,
      required this.title});

  final String title;

  final AlarmOffset initialValue;

  final Future<void> Function(AlarmOffset) onSelect;

  @override
  State<AlarmOffsetDropdownButton> createState() =>
      _AlarmOffsetDropdownButtonState();
}

class _AlarmOffsetDropdownButtonState extends State<AlarmOffsetDropdownButton> {
  // Future 캐싱을 통해 중복 호출 방지
  Future<void>? _ongoingFuture;

  static const List<AlarmOffset> alarmOffsets = AlarmOffset.values;

  static final List<DropdownMenuItem<AlarmOffset>> items = alarmOffsets
      .map((offset) =>
          DropdownMenuItem(value: offset, child: Text(offset.title)))
      .toList();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
          items: items,
          isExpanded: true,
          value: widget.initialValue,
          customButton: InfoBox(
              labelText: widget.title, currentValue: widget.initialValue.title),
          /*
              요청 처리 중이면 버튼 비활성화
             */
          onChanged: _ongoingFuture != null
              ? null
              : (value) async {
                  if (value != null) {
                    if (_ongoingFuture != null) {
                      return _ongoingFuture;
                    }

                    setState(() {
                      _ongoingFuture = widget.onSelect(value as AlarmOffset);
                    });

                    _ongoingFuture!.whenComplete(() {
                      setState(() {
                        _ongoingFuture = null;
                      });
                    });

                    return _ongoingFuture;
                  }
                }),
    );
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

class InfoBox extends StatelessWidget {
  const InfoBox(
      {super.key, required this.labelText, required this.currentValue});

  final String labelText;
  final String currentValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
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
}
