import 'package:bottom_picker/bottom_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:duary/data/save_event_req.dart';
import 'package:duary/model/enums/frequency.dart';
import 'package:duary/model/enums/weekday.dart';
import 'package:duary/model/event.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/button_base.dart';
import 'package:duary/widget/duary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key, this.event});

  final Event? event;

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late final bool isEdit;

  String title = "";
  String? location;
  String? hangOutWith;
  String? content;

  DailyRecurrence? daily;
  WeeklyRecurrence? weekly;
  MonthlyRecurrence? monthly;
  YearlyRecurrence? yearly;

  DateTime? recurStartDate;
  DateTime? recurEndDate;

  bool isTogether = false;
  bool isAllDay = false;
  late DateTime startDateTime;
  late DateTime endDateTime;
  Frequency frequency = Frequency.oneTime;

  late EventProvider eventProvider;

  @override
  void initState() {
    super.initState();
    isEdit = widget.event != null;

    if (isEdit) {
      Event event = widget.event!;
      title = event.title;
      location = event.location;
      hangOutWith = event.hangOutWith;
      content = event.content;
      isTogether = event.isTogether;
      isAllDay = event.isAllDay;
      frequency = event.frequency;
    }
    startDateTime = widget.event?.startDateTime ?? DateTime.now();
    endDateTime = widget.event?.endDateTime ??
        DateTime.now().add(const Duration(days: 1));

    eventProvider = context.read<EventProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBase(
        appBarObj: AppBar(),
        centerBuilder: (context) => Text(
          isEdit ? "일정 수정" : "일정 생성",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFFFE8F00),
          ),
        ),
        trailingBuilder: (context) => GestureDetector(
            onTap: () {
              Navigator.pop(context, false);
            },
            child: const Icon(
              Icons.close,
              color: Color(0xFF9A9A9A),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SubTitle(text: "일정 제목"),
                    const SizedBox(
                      height: 10,
                    ),
                    _TextFieldBox(
                        initialValue: title,
                        hintText: "일정 제목을 입력해주세요",
                        onChange: (text) => title = text),

                    const SizedBox(height: 11),

                    // 공동 일정으로 설정하기
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          isTogether = !isTogether;
                        });
                      },
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.task_alt,
                            color: isTogether
                                ? const Color(0xFFFFBD64)
                                : const Color(0xFFD0D0D0),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "공동 일정으로 설정하기",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isTogether
                                    ? const Color(0xFFFFBD64)
                                    : const Color(0xFFD0D0D0)),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 37,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _SubTitle(text: "진행 시간"),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              isAllDay = !isAllDay;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.task_alt,
                                color: isAllDay
                                    ? const Color(0xFFFFBD64)
                                    : const Color(0xFFD0D0D0),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text("하루종일",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: isAllDay
                                          ? const Color(0xFFFFBD64)
                                          : const Color(0xFFD0D0D0))),
                            ],
                          ),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "시작",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF646464)),
                        ),
                        Row(
                          children: [
                            _TimeBox(
                                text: _formatDate(startDateTime),
                                onTap: () async {
                                  final List<DateTime?>? value =
                                      await showDuaryCalendarPicker(
                                          true, context, []);
                                  if (value != null) {
                                    setState(() {
                                      startDateTime =
                                          DateUtils.dateOnly(value.first!);
                                    });
                                  }
                                },
                                isEnabled: true),
                            const SizedBox(
                              width: 5,
                            ),
                            _TimeBox(
                                text: _formatTime(startDateTime),
                                onTap: () async {
                                  showDuaryTimePicker(context, (time) {
                                    setState(() {
                                      startDateTime = startDateTime.copyWith(
                                          hour: time.hour, minute: time.minute);
                                    });
                                  },
                                      Time(
                                          hours: startDateTime.hour,
                                          minutes: startDateTime.minute));
                                },
                                isEnabled: !isAllDay)
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "종료",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF646464)),
                        ),
                        Row(
                          children: [
                            _TimeBox(
                                text: _formatDate(endDateTime),
                                onTap: () async {
                                  // final List<DateTime?>? value =
                                  //     await showDuaryCalendarPicker(
                                  //         true, context, [],
                                  //         firstDate: startDateTime);
                                  // if (value != null) {
                                  //   setState(() {
                                  //     endDateTime =
                                  //         DateUtils.dateOnly(value.first!);
                                  //   });
                                  // }
                                  showDuaryCalendarPicker2(context, (date) {
                                    setState(() {
                                      startDateTime = startDateTime.copyWith(
                                          year: date.year,
                                          month: date.month,
                                          day: date.day);
                                    });
                                  }, startDateTime);
                                },
                                isEnabled: true),
                            const SizedBox(
                              width: 5,
                            ),
                            _TimeBox(
                                text: _formatTime(endDateTime),
                                onTap: () {
                                  showDuaryTimePicker(context, (time) {
                                    setState(() {
                                      endDateTime = endDateTime.copyWith(
                                          hour: time.hour, minute: time.minute);
                                    });
                                  },
                                      Time(
                                          hours: endDateTime.hour,
                                          minutes: endDateTime.minute));
                                },
                                isEnabled: !isAllDay)
                          ],
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    const _SubTitle(text: "반복"),
                    const SizedBox(
                      height: 10,
                    ),

                    _RecurSection(
                      frequency: frequency,
                      onChange: (frequency, recurStartDate, recurEndDate) {},
                      startDateTime: startDateTime,
                      endDateTime: endDateTime,
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    const _SubTitle(text: "장소"),
                    const SizedBox(
                      height: 10,
                    ),
                    _TextFieldBox(
                        initialValue: location,
                        hintText: "일정이 진행되는 장소를 입력해주세요",
                        onChange: (text) => location = text),

                    const SizedBox(
                      height: 30,
                    ),

                    const _SubTitle(text: "만나는 사람"),
                    const SizedBox(
                      height: 10,
                    ),
                    _TextFieldBox(
                        initialValue: hangOutWith,
                        hintText: "만나는 사람을 입력해주세요",
                        onChange: (text) => hangOutWith = text),

                    const SizedBox(
                      height: 30,
                    ),

                    const _SubTitle(text: "메모"),
                    const SizedBox(
                      height: 10,
                    ),
                    _TextFieldBox(
                        initialValue: content,
                        hintText: "메모를 입력해주세요",
                        onChange: (text) => content = text,
                        maxLines: 4),
                    const SizedBox(height: 30,),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                ButtonBase(
                  onTap: () async {
                    SaveEventReq req = getSaveReq();
                    await eventProvider.saveEvent(req).then((_) {
                      Navigator.pop(context, true);
                    }).catchError((e) {
                      Fluttertoast.showToast(msg: e.toString());
                    });
                  },
                  child: Container(
                    // margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFBD64),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        isEdit ? "일정 수정하기" : "새 일정 등록하기",
                        style: const TextStyle(
                            color: Color(0xFF573200),
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,)
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat("aa hh:mm", "ko").format(time);
  }

  SaveEventReq getSaveReq() {
    return SaveEventReq(
        startDateTime,
        endDateTime,
        recurStartDate,
        recurEndDate,
        frequency,
        daily,
        weekly,
        monthly,
        yearly,
        title,
        content,
        location,
        hangOutWith,
        isTogether,
        isAllDay);
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox(
      {super.key,
      required this.text,
      required this.onTap,
      required this.isEnabled});

  final String text;
  final void Function() onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF3F3F3),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isEnabled
                  ? const Color(0xFF333333)
                  : const Color(0xFFD9D9D9)),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return "${DateFormat("yyyy. M. d.").format(date)} ${DateFormat.E("ko_KR").format(date)}요일";
}

class _TextFieldBox extends StatelessWidget {
  const _TextFieldBox(
      {super.key,
      this.initialValue,
      required this.hintText,
      required this.onChange,
      this.maxLines,
      this.textAlign,
      this.inputFormatters,
      this.controller});

  final String? initialValue;
  final String hintText;
  final void Function(String) onChange;
  final int? maxLines;
  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      maxLines: maxLines,
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChange,
      textAlign: textAlign ?? TextAlign.start,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFFD0D0D0)),
          fillColor: const Color(0xFFF3F3F3),
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          border: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(10))),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 18, color: Color(0xFF323232), fontWeight: FontWeight.w600),
    );
  }
}

class _RecurSection extends StatefulWidget {
  const _RecurSection(
      {required this.frequency,
      required this.onChange,
      required this.startDateTime,
      required this.endDateTime});

  final Frequency frequency;

  final Function(Frequency, DateTime?, DateTime?) onChange;

  final DateTime startDateTime;
  final DateTime endDateTime;

  @override
  State<_RecurSection> createState() => _RecurSectionState();
}

class _RecurSectionState extends State<_RecurSection> {
  late Frequency frequency;

  static const List<Frequency> frequencies = Frequency.values;

  static final List<DropdownMenuItem<Frequency>> items = frequencies
      .map((f) => DropdownMenuItem(value: f, child: Text(f.title)))
      .toList();

  DailyRecurrence? daily;
  WeeklyRecurrence? weekly;
  MonthlyRecurrence? monthly;
  YearlyRecurrence? yearly;

  DateTime recurStartDate = DateUtils.dateOnly(DateTime.now());
  DateTime? recurEndDate;

  bool hasRecurEndDate = false;

  late final DateTime startDateTime;
  late final DateTime endDateTime;

  @override
  void initState() {
    frequency = widget.frequency;
    startDateTime = widget.startDateTime;
    endDateTime = widget.endDateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            items: items,
            isExpanded: true,
            value: widget.frequency,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  frequency = value;
                  hasRecurEndDate = false;
                });
              }
            },
            customButton: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF3F3F3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    frequency.title,
                    style: TextStyle(
                        fontSize: 16,
                        color: frequency != Frequency.oneTime
                            ? const Color(0xFF333333)
                            : const Color(0xFFD0D0D0)),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFFB6B6B6),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        getRecurSection(),
        const SizedBox(
          height: 10,
        ),
        frequency != Frequency.oneTime
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("반복 종료"),
                      const SizedBox(
                        width: 8,
                      ),
                      _TimeBox(
                          text: hasRecurEndDate ? "날짜" : "안 함",
                          onTap: () {
                            setState(() {
                              hasRecurEndDate = !hasRecurEndDate;
                              recurEndDate ??= DateTime.now()
                                    .add(const Duration(days: 90));
                            });
                          },
                          isEnabled: true),
                      const SizedBox(
                        width: 8,
                      ),
                      _TimeBox(
                          text: recurEndDate != null
                              ? _formatDate(recurEndDate!)
                              : "설정해주세요",
                          onTap: () {
                            if (hasRecurEndDate) {
                              showDuaryCalendarPicker(true, context, [],
                                      firstDate: endDateTime)
                                  .then((selected) {
                                if (selected != null) {
                                  setState(() {
                                    recurEndDate = selected.first!;
                                  });
                                }
                              });
                            }
                          },
                          isEnabled: hasRecurEndDate)
                    ],
                  ),
                ],
              )
            : Container()
      ],
    );
  }

  Widget getRecurSection() {
    switch (frequency) {
      case Frequency.oneTime:
        return Container();
      case Frequency.daily:
        return _DailyRecurSection(
          onChange: (interval) {
            daily = DailyRecurrence(interval);
          },
        );
      case Frequency.weekly:
        return _WeeklyRecurSection(
          onSelect: (selected) {
            weekly = WeeklyRecurrence(selected);
          },
        );
      case Frequency.monthly:
        return _MonthlyRecurSection(
          onSelect: (days) {
            monthly = MonthlyRecurrence(days);
          },
        );
      case Frequency.yearly:
        return _YearlyRecurSection(recurDate: startDateTime);
    }
  }
}

class _DailyRecurSection extends StatefulWidget {
  const _DailyRecurSection({super.key, required this.onChange});

  final Function(int) onChange;

  @override
  State<_DailyRecurSection> createState() => _DailyRecurSectionState();
}

class _DailyRecurSectionState extends State<_DailyRecurSection> {
  final TextEditingController controller = TextEditingController();

  int interval = 1;

  @override
  void initState() {
    widget.onChange(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: _TextFieldBox(
            controller: controller,
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            hintText: "",
            onChange: (value) {
              if (value.isEmpty) return;
              // 1년을 넘지 않게
              int temp = int.parse(value);
              if (temp > 365) {
                temp = 365;
              }
              controller.text = temp.toString();
              setState(() {
                interval = temp;
              });
              widget.onChange(interval);
            },
            maxLines: 1,
          ),
        ),
        const Text("일마다 반복")
      ],
    );
  }
}

class _WeeklyRecurSection extends StatefulWidget {
  const _WeeklyRecurSection({required this.onSelect});

  final Function(List<Weekday>) onSelect;

  @override
  State<_WeeklyRecurSection> createState() => _WeeklyRecurSectionState();
}

class _WeeklyRecurSectionState extends State<_WeeklyRecurSection> {
  final List<Weekday> selected = [];

  @override
  Widget build(BuildContext context) {
    final List<Widget> weekdays = Weekday.values
        .map((weekday) => GestureDetector(
            onTap: () {
              setState(() {
                if (selected.contains(weekday)) {
                  selected.remove(weekday);
                } else {
                  selected.add(weekday);
                }
                selected.sort((w1, w2) {
                  return w1.value - w2.value;
                });
              });
              widget.onSelect(selected);
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: selected.contains(weekday) ? Colors.yellow : null),
                child: Text(
                  weekday.title,
                ))))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: weekdays,
        ),
        selected.isEmpty
            ? const Text("")
            : Text("${selected.join(",")}요일 마다 반복됩니다")
      ],
    );
  }
}

class _MonthlyRecurSection extends StatefulWidget {
  const _MonthlyRecurSection({required this.onSelect});

  final Function(List<int>) onSelect;

  @override
  State<_MonthlyRecurSection> createState() => _MonthlyRecurSectionState();
}

class _MonthlyRecurSectionState extends State<_MonthlyRecurSection> {
  final List<int> selected = [];

  @override
  Widget build(BuildContext context) {
    final List<List<DateTime?>> weeks =
        _generateDaysForMonth(2024, 12); // 1일이 일요일부터 시작하고, 31일까지 있는 달
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildCalendarBody(weeks),
        selected.isEmpty
            ? const Text("")
            : Text("${selected.join("일,")}일 마다 반복됩니다")
      ],
    );
  }

  Widget _buildCalendarBody(List<List<DateTime?>> weeks) {
    return Table(
      children: weeks.map((week) {
        return TableRow(
          children: week.map((day) {
            if (day == null) {
              return const SizedBox(height: 40);
            } else {
              // 날짜 그리기
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    if (selected.contains(day.day)) {
                      selected.remove(day.day);
                    } else {
                      selected.add(day.day);
                    }
                    selected.sort();
                  });
                  widget.onSelect(selected);
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: selected.contains(day.day)
                                ? Colors.yellow
                                : null),
                        child: Text(
                          "${day.day}",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF656565)),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
              );
            }
          }).toList(),
        );
      }).toList(),
    );
  }

  // 지정한 연/월에 대한 날짜를 2차원 리스트(주 단위)로 생성하는 함수
  List<List<DateTime?>> _generateDaysForMonth(int year, int month) {
    final DateTime firstDayOfMonth = DateTime(year, month, 1);
    final DateTime lastDayOfMonth =
        DateTime(year, month + 1, 1).subtract(const Duration(days: 1));
    final int daysInMonth = lastDayOfMonth.day;

    // Dart의 weekday는 월(1) ~ 일(7)이므로, 일요일을 0으로 보정해서 시작 위치를 계산
    int startingWeekday = firstDayOfMonth.weekday % 7;

    List<List<DateTime?>> weeks = [];
    List<DateTime?> currentWeek = [];

    // 첫 주 앞부분 빈 칸 추가
    for (int i = 0; i < startingWeekday; i++) {
      currentWeek.add(null);
    }
    for (int day = 1; day <= daysInMonth; day++) {
      currentWeek.add(DateTime(year, month, day));
      if (currentWeek.length == 7) {
        weeks.add(currentWeek);
        currentWeek = [];
      }
    }
    // 마지막 주에 남은 빈 칸 채우기
    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        currentWeek.add(null);
      }
      weeks.add(currentWeek);
    }
    return weeks;
  }
}

class _YearlyRecurSection extends StatelessWidget {
  const _YearlyRecurSection({super.key, required this.recurDate});

  final DateTime recurDate;

  @override
  Widget build(BuildContext context) {
    return Text(DateFormat("M월 d일 마다 반복됩니다").format(recurDate));
  }
}
