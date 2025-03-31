import 'package:duary/model/enums/character.dart';
import 'package:duary/model/event.dart';
import 'package:duary/provider/auth_provider.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class MonthCalendar extends StatefulWidget {
  const MonthCalendar(
      {super.key,
      required this.initialDate,
      required this.onDateTap,
      required this.onYearTap});

  final DateTime initialDate;
  final void Function(DateTime) onYearTap;
  final void Function(DateTime) onDateTap;

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  // 충분히 큰 초기 페이지를 지정해서, 양쪽 방향으로 스와이프 가능하게 함.
  static const _totalPage = 500;
  static const _initialPage = 250;
  late final PageController _pageController;

  late DateTime focusMonth;

  @override
  void initState() {
    focusMonth = widget.initialDate;

    _pageController = PageController(initialPage: _initialPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // appbar
        SizedBox(
          width: double.infinity,
          height: 58,
          child: Stack(
            children: [
              Positioned(
                  left: 20,
                  top: 18,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.onYearTap(focusMonth);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.chevron_left),
                        Text(
                          "${focusMonth.year}년",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        )
                      ],
                    ),
                  )),
              Center(
                child: Text(
                  "${focusMonth.month}월",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFE8F00)),
                ),
              )
            ],
          ),
        ),

        // body
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _totalPage,
            onPageChanged: (index) {
              setState(() {
                // index와 initialPage의 차이를 이용해 현재 페이지의 달을 계산
                final int monthOffset = index - _initialPage;

                focusMonth = DateTime(
                  widget.initialDate.year,
                  widget.initialDate.month + monthOffset,
                  1,
                );
              });
            },
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                child: _CalendarMonthWidget(
                  year: focusMonth.year,
                  month: focusMonth.month,
                  onDateTap: widget.onDateTap,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CalendarMonthWidget extends StatefulWidget {
  final int year;
  final int month;

  final void Function(DateTime) onDateTap;

  const _CalendarMonthWidget(
      {super.key,
      required this.year,
      required this.month,
      required this.onDateTap});

  @override
  State<_CalendarMonthWidget> createState() => _CalendarMonthWidgetState();
}

class _CalendarMonthWidgetState extends State<_CalendarMonthWidget> {
  late DuaryContext _eventProvider;
  final AuthProvider _authProvider = AuthProvider();

  @override
  void initState() {
    super.initState();

    _eventProvider = context.read<DuaryContext>();
  }

  @override
  Widget build(BuildContext context) {
    final List<List<DateTime?>> weeks =
        _generateDaysForMonth(widget.year, widget.month);
    return Column(
      children: [
        // 요일 라벨
        _buildWeekdayLabels(),
        const SizedBox(
          height: 12,
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: const Color(0xFFF3F3F3),
        ),
        // 날짜 그리드
        Expanded(
            child: FutureBuilder(
                future: _eventProvider.getEventByMonth(
                    DateTime(widget.year, widget.month, 1)),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    Fluttertoast.showToast(msg: "오류가 발생했습니다");
                  }
                  return _buildCalendarBody(weeks, snapshot.data);
                })),
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    const weekdays = ["일", "월", "화", "수", "목", "금", "토"];
    return Row(
      children: weekdays.map((day) {
        late Color fontColor;
        if (day == "일") {
          fontColor = const Color(0xFFF22424);
        } else if (day == "토") {
          fontColor = const Color(0xFF4058F9);
        } else {
          fontColor = const Color(0xFF858585);
        }
        return Expanded(
          child: Center(
            child: Text(day,
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: fontColor)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarBody(List<List<DateTime?>> weeks, List<Event>? events) {
    return Table(
      children: weeks.map((week) {
        return TableRow(
          children: week.map((day) {
            if (day == null) {
              return const SizedBox(height: 40);
            } else {
              // 날짜 아래 점 찍기
              late Widget dot;
              if (events == null) {
                dot = Container();
              } else {
                // 해당 날짜의 이벤트 필터링
                List<Event> dayEvents = events
                    .where((event) => event.startDateTime.day == day.day)
                    .toList();
                if (dayEvents.isEmpty) {
                  dot = Container();
                } else {
                  List<int> dotIndex = [-1, -1, -1];
                  // 해당 날짜에 함께하는 일정이 아니고, 내 일정이 있는 경우 내 점 찍기
                  dotIndex[0] = dayEvents.indexWhere((event) =>
                      event.memberSocialId == _authProvider.me!.socialId &&
                      !event.isTogether);
                  // 해당 날짜에 함께하는 일정이 아니고, 상대방 일정이 있는 경우 상대방 점 찍기
                  dotIndex[1] = dayEvents.indexWhere((event) =>
                      event.memberSocialId != _authProvider.me!.socialId &&
                      !event.isTogether);
                  // 해당 날짜에 함께하는 일정이 있으면 분홍색 점 찍기
                  dotIndex[2] =
                      dayEvents.indexWhere((event) => event.isTogether);

                  dotIndex = dotIndex.where((i) => i != -1).toList();
                  dot = ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: dotIndex.length,
                    itemBuilder: (context, index) {
                      Event event = events[dotIndex[index]];
                      if (event.isTogether) {
                        return _CalendarDot(
                            color: Character.together.characterColor);
                      }
                      return _CalendarDot(
                          color: event.member.character.characterColor);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      width: 3,
                    ),
                  );
                }
              }
              // 날짜 그리기
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  widget.onDateTap(day);
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        "${day.day}",
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF656565)),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      SizedBox(height: 5, child: dot)
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

class _CalendarDot extends StatelessWidget {
  const _CalendarDot({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(99),
      ),
      height: 5,
      width: 5,
    );
  }
}
