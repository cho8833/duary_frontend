import 'package:duary/widget/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';

class InputCoupleInfoScreen extends StatefulWidget {
  const InputCoupleInfoScreen({super.key});

  @override
  State<InputCoupleInfoScreen> createState() => _InputCoupleInfoScreenState();
}

class _InputCoupleInfoScreenState extends State<InputCoupleInfoScreen> {
  String name = '';
  bool isName = false;

  Text nameErrorMssg = const Text('');
  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now(),
  ];
  DateTime? birthdayFormat = DateTime(0, 0, 0);
  bool isBirthday = false;

  Text birthdayErrorMssg = const Text('');

  DateTime? coupleFormat = DateTime(0, 0, 0);
  bool isCouple = false;

  Text coupleErrorMssg = const Text('');

  bool blue = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar(appBarObj: AppBar()),
      body: Column(
        children: [
          const SizedBox(
            height: 56, //58
          ),
          welcomeMssg(),
          const SizedBox(
            height: 40,
          ),
          inputName(),
          inputBirthday(),
          inputCoupleday(),
          characterChange(),
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
            height: 48, //45
          ),
          startDuary(),
          const SizedBox(
            height: 32, //30
          ),
          serviceMssg(),
        ],
      ),
    );
  }

  Column serviceMssg() {
    return const Column(
      children: [
        Text(
          '위 내용은 연결된 상대방의 Duary에도 보이며',
          style: TextStyle(
            color: Color(0xFFCBCBCB),
            fontFamily: 'NanumSquareRound',
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          '마이페이지에서 변경 가능합니다. 입력하신',
          style: TextStyle(
            color: Color(0xFFCBCBCB),
            fontFamily: 'NanumSquareRound',
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          '모든 정보는 서비스 최적화를 위해서만 사용됩니다.',
          style: TextStyle(
            color: Color(0xFFCBCBCB),
            fontFamily: 'NanumSquareRound',
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Column welcomeMssg() {
    return const Column(
      children: [
        Text(
          '만나서 반가워요!',
          style: TextStyle(
            color: Color(0xFFFF9000),
            fontFamily: 'NanumSquareRound',
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
            fontFamily: 'NanumSquareRound',
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Padding startDuary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: GestureDetector(
        onTap: () {
          if (isName == false) {
            setState(
              () {
                nameErrorMssg = _nameErrorMssg();
              },
            );
          }
          if (isBirthday == false) {
            setState(
              () {
                birthdayErrorMssg = _birthdayErrorMssg();
              },
            );
          }
          if (isCouple == false) {
            setState(
              () {
                coupleErrorMssg = _coupleErrorMssg();
              },
            );
          }
          //else {저장 후 다음 페이지로}
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
              fontFamily: 'NanumSquareRound',
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          )),
        ),
      ),
    );
  }

  Padding inputName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Icon(
                Icons.task_alt,
                color:
                    isName ? const Color(0xFFFFBD64) : const Color(0xFFD4D4D4),
              ),
            ),
            //icon 위치 조정하기
            const SizedBox(
              width: 13,
            ),
            Flexible(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 250,
                        height: 33,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isName
                                  ? const Color(0xFFFFBD64)
                                  : const Color(0xFFD4D4D4),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        height: 33,
                        child: TextField(
                          onChanged: (value) {
                            name = value;
                            print(name); //저장된 텍스트 확인
                            setState(() {
                              validateName();
                            });
                          },
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF3F3F3F),
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: '내 이름 / 닉네임',
                            hintStyle: _textStyle(),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 250,
                    height: 25,
                    child: nameErrorMssg,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding inputBirthday() {
    String birthday = DateFormat('yy.MM.dd').format(birthdayFormat!);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: SizedBox(
          width: double.infinity,
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Icon(
                  Icons.task_alt,
                  color: isBirthday
                      ? const Color(0xFFFFBD64)
                      : const Color(0xFFD4D4D4),
                ),
              ),
              //icon 위치 조정하기
              const SizedBox(
                width: 13,
              ),
              Flexible(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 250,
                          height: 33,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isBirthday
                                    ? const Color(0xFFFFBD64)
                                    : const Color(0xFFD4D4D4),
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Center(
                            child: isBirthday
                                ? Text(
                                    birthday,
                                    style: const TextStyle(
                                      color: Color(0xFF3F3F3F),
                                      fontFamily: 'Pretendard',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : const Text(
                                    '내 생년월일',
                                    style: TextStyle(
                                      color: Color(0xFFD4D4D4),
                                      fontFamily: 'Pretendard',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                          //텍스트 위치 조정
                        ),
                        SizedBox(
                          width: 250,
                          height: 33,
                          child: _buildBirthdayDialogButton(),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 250,
                      height: 25,
                      child: birthdayErrorMssg,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Padding inputCoupleday() {
    String couple = DateFormat('yy.MM.dd').format(coupleFormat!);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 64,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Icon(
                Icons.task_alt,
                color: isCouple
                    ? const Color(0xFFFFBD64)
                    : const Color(0xFFD4D4D4),
              ),
            ),
            //icon 위치 조정하기
            const SizedBox(
              width: 13,
            ),
            Flexible(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 250,
                        height: 33,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isCouple
                                  ? const Color(0xFFFFBD64)
                                  : const Color(0xFFD4D4D4),
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Center(
                          child: isCouple
                              ? Text(
                                  couple,
                                  style: const TextStyle(
                                    color: Color(0xFF3F3F3F),
                                    fontFamily: 'Pretendard',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : const Text(
                                  '우리가 처음 만난 날',
                                  style: TextStyle(
                                    color: Color(0xFFD4D4D4),
                                    fontFamily: 'Pretendard',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                        //텍스트 위치 조정
                      ),
                      SizedBox(
                        width: 250,
                        height: 33,
                        child: _buildCoupleDialogButton(),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 250,
                    height: 25,
                    child: coupleErrorMssg,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _textStyle() {
    return const TextStyle(
      color: Color(0xFFE3DDD7),
      fontFamily: 'Pretendard',
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }

  void validateName() {
    if (name.isEmpty) {
      isName = false;
    } else {
      isName = true;
      nameErrorMssg = _nameErrorMssg();
    }
  }

  Text _nameErrorMssg() {
    if (isName) {
      return const Text('');
    } else {
      return const Text(
        '이름을 입력해주세요',
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.redAccent,
          fontFamily: 'NanumSquareRound',
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      );
    }
  }

  Text _birthdayErrorMssg() {
    if (isBirthday) {
      return const Text('');
    } else {
      return const Text(
        '날짜를 입력해주세요',
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.redAccent,
          fontFamily: 'NanumSquareRound',
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      );
    }
  }

  Text _coupleErrorMssg() {
    if (isCouple) {
      return const Text('');
    } else {
      return const Text(
        '날짜를 입력해주세요',
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.redAccent,
          fontFamily: 'NanumSquareRound',
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      );
    }
  }

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
                    // ignore: avoid_print
                    print(_getValueText(
                      config.calendarType,
                      value,
                    ));
                    birthdayFormat = value.first; //날짜 저장, 포매터 (이름 변경 필요)
                    setState(() {
                      _dialogCalendarPickerValue = value;
                      isBirthday = true;
                      birthdayErrorMssg = _birthdayErrorMssg();
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

  _buildCoupleDialogButton() {
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
                    // ignore: avoid_print
                    print(_getValueText(
                      config.calendarType,
                      value,
                    ));
                    coupleFormat = value.first;
                    setState(() {
                      _dialogCalendarPickerValue = value;
                      isCouple = true;
                      coupleErrorMssg = _coupleErrorMssg();
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

  SizedBox characterChange() {
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
          blue = false;
          setState(() {
            characterChange();
          });
        },
        child: Image.asset(
          'asset/blue.png',
          width: 60,
          height: 103,
        ),
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
            blue = true;
            setState(() {
              characterChange();
            });
          },
          child: Image.asset(
            'asset/yellow.png',
            width: 60,
            height: 60,
          ),
        ),
      ),
    );
  }
}
