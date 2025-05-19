import 'package:duary/model/enums/character.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/repository/couple_repository.dart';
import 'package:duary/screen/connect_copule_screen.dart';
import 'package:duary/screen/login_screen.dart';
import 'package:duary/widget/button_base.dart';

import 'package:duary/support/repository_container.dart';
import 'package:duary/widget/characters.dart';
import 'package:duary/widget/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class StartDuaryScreen extends StatefulWidget {
  const StartDuaryScreen({super.key});

  @override
  State<StartDuaryScreen> createState() => _StartDuaryScreenState();
}

class _StartDuaryScreenState extends State<StartDuaryScreen> {
  final DuaryContext duaryContext = DuaryContext();

  CoupleRepository coupleRepository = RepositoryContainer().coupleRepository;

  String name = '';
  bool isName = false;
  String nameErrorMssg = "";

  DateTime birthday = DateTime(0, 0, 0);
  bool isBirthday = false;
  String birthdayErrorMssg = "";

  DateTime relationDate = DateTime(0, 0, 0);
  bool isRelationDate = false;
  String relationDateErrorMssg = "";

  bool blue = true;

  late Character myCharacter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar(appBarObj: AppBar()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 56, //58
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
                  height: 8, //7
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
            inputInfo(
                hintText: "내 이름 / 닉네임",
                myInfo: "",
                inputBy: nameInputter(),
                validateBy: isName,
                errorMessage: nameErrorMssg,
                expandIcon: false),
            inputInfo(
              hintText: "내 생년월일",
              inputBy: _buildBirthdayDialogButton(),
              myInfo: formatDateTime(birthday),
              validateBy: isBirthday,
              errorMessage: birthdayErrorMssg,
              expandIcon: true,
            ),
            inputInfo(
              hintText: "우리가 처음 만난 날",
              inputBy: _buildRelationDateDialogButton(),
              myInfo: formatDateTime(relationDate),
              validateBy: isRelationDate,
              errorMessage: relationDateErrorMssg,
              expandIcon: true,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonBase(
                  onTap: () async {
                    setState(() {
                      blue ? blue = false
                          : blue = true;
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
                ButtonBase(
                  onTap: () async {
                    setState(() {
                      blue ? blue = false
                          : blue = true;
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: GestureDetector(
                onTap: () async {
                  if (name.isEmpty == true) {
                    setState(
                      () {
                        nameErrorMssg = "이름을 입력해주세요";
                      },
                    );
                  }
                  if (isBirthday == false) {
                    setState(
                      () {
                        birthdayErrorMssg = "생일을 입력해주세요";
                      },
                    );
                  }
                  if (isRelationDate == false) {
                    setState(
                      () {
                        relationDateErrorMssg = "처음 만난 날을 입력해주세요";
                      },
                    );
                  }
                  if (name.isEmpty == false &&
                      isBirthday == true &&
                      isRelationDate == true) {
                    blue
                        ? myCharacter = Character.blue
                        : myCharacter = Character.yellow;

                    await duaryContext
                        .startDuary(name, birthday, relationDate, myCharacter)
                        .then((_) {
                      //validate 구현 필요
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ConnectCoupleScreen()),
                          (p) => false);
                    }).catchError((e) {
                      Fluttertoast.showToast(msg: e.toString());
                    });
                  }
                },
                child: Container(
                  width: 304,
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
            ),
            const SizedBox(
              height: 16,
            ),
            ButtonBase(
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
    );
  }

  TextField nameInputter() => TextField(
        onChanged: (value) {
          name = value;
          setState(() {
            if (name.isEmpty == true) {
              isName = false;
            } else {
              isName = true;
              nameErrorMssg = "";
            }
          });
        },
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF3F3F3F),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      );

  Padding inputInfo({
    required String hintText,
    required dynamic inputBy,
    required String myInfo,
    required bool validateBy,
    required String errorMessage,
    required bool expandIcon,
  }) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: validateBy
                        ? Text(
                            myInfo,
                            style: const TextStyle(
                              color: Color(0xFF3F3F3F),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Text(
                            hintText,
                            style: const TextStyle(
                              color: Color(0xFF6F6F6F),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
                expandIcon
                    ? const Positioned(
                        top: 12,
                        right: 16,
                        child: Icon(
                          Icons.expand_more_rounded,
                          color: Color(0xFF6F6F6F),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: inputBy,
                )
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 16,
              child: Text(
                errorMessage,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ));
  }

  String formatDateTime(DateTime req) => DateFormat('yy.MM.dd').format(req);

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> value,
  ) {
    value = value.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (value.isNotEmpty ? value[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    return valueText;
  }

  _buildBirthdayDialogButton() {
    List<DateTime?> _dialogCalendarPickerValue = [
      DateTime.now(),
    ];
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: const Color(0xFFFFBD64),
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Color(0xFFFFBD64),
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return SizedBox(
      width: 230,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ElevatedButton(
                onPressed: () async {
                  final value = await showCalendarDatePicker2Dialog(
                    context: context,
                    config: config,
                    dialogSize: const Size(325, 370),
                    borderRadius: BorderRadius.circular(10),
                    value: _dialogCalendarPickerValue,
                    dialogBackgroundColor: Colors.white,
                  );

                  if (value != null) {
                    birthday = DateTime(value.first!.year, value.first!.month, value.first!.day);
                    setState(() {
                      _dialogCalendarPickerValue = value;
                      isBirthday = true;
                      birthdayErrorMssg = "";
                    });
                  }
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  shadowColor: WidgetStatePropertyAll(Colors.transparent),
                ),
                child: const SizedBox(
                  width: 230,
                  height: 33,
                )),
          ),
        ],
      ),
    );
  }

  _buildRelationDateDialogButton() {
    List<DateTime?> _dialogCalendarPickerValue = [
      DateTime.now(),
    ];
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: const Color(0xFFFFBD64),
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Color(0xFFFFBD64),
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return SizedBox(
      width: 230,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ElevatedButton(
                onPressed: () async {
                  final value = await showCalendarDatePicker2Dialog(
                    context: context,
                    config: config,
                    dialogSize: const Size(325, 370),
                    borderRadius: BorderRadius.circular(10),
                    value: _dialogCalendarPickerValue,
                    dialogBackgroundColor: Colors.white,
                  );

                  if (value != null) {
                    relationDate = DateTime(value.first!.year, value.first!.month, value.first!.day);
                    setState(() {
                      _dialogCalendarPickerValue = value;
                      isRelationDate = true;
                      relationDateErrorMssg = "";
                    });
                  }
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  shadowColor: WidgetStatePropertyAll(Colors.transparent),
                  enableFeedback: false,
                ),
                child: const SizedBox(
                  width: 230,
                  height: 33,
                )),
          ),
        ],
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
