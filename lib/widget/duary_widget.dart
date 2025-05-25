import 'package:duary/widget/button_base.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';

class DuaryTextInputBox extends StatefulWidget {
  const DuaryTextInputBox(
      {super.key, this.hintText, required this.onChange, this.initialValue});

  final String? hintText;

  final String? initialValue;

  final void Function(String) onChange;

  @override
  State<DuaryTextInputBox> createState() => _DuaryTextInputBoxState();
}

class _DuaryTextInputBoxState extends State<DuaryTextInputBox> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.initialValue ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        onChanged: widget.onChange,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF3F3F3F),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class DuaryDateInputBox extends StatefulWidget {
  const DuaryDateInputBox(
      {super.key,
      this.initialValue,
      this.hintText,
      required this.onSelect,
      this.futureDateSelectable = true,});

  final DateTime? initialValue;

  final void Function(DateTime) onSelect;

  final String? hintText;

  final bool futureDateSelectable;

  @override
  State<DuaryDateInputBox> createState() => _DuaryDateInputBoxState();
}

class _DuaryDateInputBoxState extends State<DuaryDateInputBox> {
  //날짜 선택 위젯창 현재값
  late List<DateTime?> currentPickValue;

  //현재 박스에 표시되는 값
  late String currentValue;

  late final CalendarDatePicker2WithActionButtonsConfig config;

  @override
  void initState() {
    currentPickValue = [
      widget.initialValue ?? DateTime.now(),
    ];
    currentValue = widget.initialValue != null
        ? DateFormat('yy.MM.dd').format(widget.initialValue!)
        : "";
    //날짜 선택 위젯창 구현부
    config = CalendarDatePicker2WithActionButtonsConfig(
      lastDate: widget.futureDateSelectable ? null : DateTime.now(),
      calendarType: CalendarDatePicker2Type.single,
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
      dayTextStyle:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      selectedDayHighlightColor: const Color(0xFFFFBD64),
      closeDialogOnCancelTapped: true,
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
      selectedDayTextStyle:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.w700)
              .copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday) {
          textStyle =
              TextStyle(color: Colors.blue[500], fontWeight: FontWeight.w600);
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25)) ||
            date.weekday == DateTime.sunday) {
          textStyle = TextStyle(
            color: Colors.red[400],
            fontWeight: FontWeight.w700,
          );
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      onTap: () async {
        final value = await showCalendarDatePicker2Dialog(
          context: context,
          config: config,
          dialogSize: const Size(325, 370),
          borderRadius: BorderRadius.circular(10),
          value: currentPickValue,
          dialogBackgroundColor: Colors.white,
        );

        if (value != null) {
          widget.onSelect(value.first!);
          setState(() {
            currentPickValue = value;
            currentValue = DateFormat('yy.MM.dd').format(value.first!);
          });
        }
      },
      child: Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                ),
                Text(
                  currentValue.isNotEmpty ? currentValue : widget.hintText!,
                  style: const TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.expand_more,
                  color: Color(0xFF6F6F6F),
                )
              ],
            ),
          )),
    );
  }
}
