import 'package:duary/model/enums/character.dart';
import 'package:duary/model/event.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/screen/home_screen.dart';
import 'package:duary/screen/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MonthCalendar extends StatefulWidget {
  const MonthCalendar({super.key, required this.timeTableController});

  final TimeTableController timeTableController;

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  // 충분히 큰 초기 페이지를 지정해서, 양쪽 방향으로 스와이프 가능하게 함.
  static const _totalPage = 500;
  static const _initialPage = 250;
  late final PageController _pageController =
      PageController(initialPage: _initialPage);

  late TimeTableController timeTableController = widget.timeTableController;
  late final ValueNotifier<DateTime> focusMonthNotifier =
      ValueNotifier(timeTableController.focusMonth.value);
  late DateTime initialMonth = focusMonthNotifier.value;

  late DateTime selectedDay = timeTableController.focusDay.value;

  List<Event> dayEvents = [];

  late final EventProvider eventProvider = context.read<EventProvider>();

  @override
  void initState() {
    super.initState();
    timeTableController.focusMonth.addListener(monthListener);
    eventProvider.getEventByDay(selectedDay).then((events) {
      WidgetsBinding.instance.addPostFrameCallback((d) {
        setState(() {
          dayEvents = events;
        });
      });
    });
  }

  void monthListener() {
    setState(() {
      initialMonth = timeTableController.focusMonth.value;
    });
  }

  @override
  void dispose() {
    timeTableController.focusMonth.removeListener(monthListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // appbar
        ValueListenableBuilder(
          builder: (context, value, child) {
            return SizedBox(
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
                          timeTableController.moveToYear(value);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.chevron_left),
                            Text(
                              "${value.year}년",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            )
                          ],
                        ),
                      )),
                  Positioned(
                    right: 20,
                    top: 18,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        timeTableController.moveToDay(selectedDay);
                      },
                      child: Row(
                        children: [
                          Text(
                            "${selectedDay.day}일",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "${value.month}월",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFE8F00)),
                    ),
                  )
                ],
              ),
            );
          },
          valueListenable: focusMonthNotifier,
        ),
        // body
        SizedBox(
          height: 256,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _totalPage,
            onPageChanged: (index) {
              // index와 initialPage의 차이를 이용해 현재 페이지의 달을 계산
              final int monthOffset = index - _initialPage;

              focusMonthNotifier.value = DateTime(
                initialMonth.year,
                initialMonth.month + monthOffset,
                1,
              );
            },
            itemBuilder: (context, index) {
              final int monthOffset = index - _initialPage;
              final DateTime currentMonth = DateTime(
                  initialMonth.year, initialMonth.month + monthOffset, 1);
              return Container(
                color: Colors.white,
                child: _CalendarMonthWidget(
                  year: currentMonth.year,
                  month: currentMonth.month,
                  selectedDay: selectedDay,
                  onSelectDay: (DateTime day) {
                    if (DateUtils.isSameDay(day, selectedDay)) {
                      timeTableController.moveToDay(day);
                    } else {
                      selectedDay = day;
                      eventProvider.getEventByDay(selectedDay).then((events) {
                        setState(() {
                          dayEvents = events;
                        });
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: dayEvents.isNotEmpty ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Event event = dayEvents[index];
                  return Column(
                    children: [
                      ComingEventCard(event: event),
                      const SizedBox(height: 8,),
                    ],
                  );
                },
                itemCount: dayEvents.length) : const Center(child: Text("일정이 없어요"),),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${DateFormat("yyyy년 M월 dd일").format(date)} ${DateFormat.E("ko_KR").format(date)}요일";
  }
}

class _CalendarMonthWidget extends StatefulWidget {
  final int year;
  final int month;
  final void Function(DateTime) onSelectDay;
  final DateTime selectedDay;

  const _CalendarMonthWidget(
      {super.key,
      required this.year,
      required this.month,
      required this.onSelectDay,
      required this.selectedDay});

  @override
  State<_CalendarMonthWidget> createState() => _CalendarMonthWidgetState();
}

class _CalendarMonthWidgetState extends State<_CalendarMonthWidget> {
  late EventProvider _eventProvider;
  final DuaryContext _duaryContext = DuaryContext();

  Map<DateTime, List<Event>>? data;

  @override
  void initState() {
    super.initState();

    _eventProvider = context.read<EventProvider>();
    _eventProvider.addListener(_eventListener);
    _eventProvider.getEventByMonth(DateTime(widget.year, widget.month, 1)).then((events) {
      WidgetsBinding.instance.addPostFrameCallback((d) {
        data = events;
      });
    });
  }

  void _eventListener() {
    _eventProvider.getEventByMonth(DateTime(widget.year, widget.month, 1)).then((d) {
      setState(() {
        data = d;
      });
    });
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
        _buildCalendarBody(weeks, data)
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

  Widget _buildCalendarBody(
      List<List<DateTime?>> weeks, Map<DateTime, List<Event>>? events) {
    return Table(
      children: weeks.map((week) {
        return TableRow(
          children: week.map((day) {
            if (day == null) {
              return const SizedBox(height: 32);
            } else {
              // 날짜 아래 점 찍기
              late Widget dot;
              // 해당 날짜의 이벤트 필터링
              List<Event>? dayEvents = events?[day];

              if (dayEvents == null || dayEvents.isEmpty) {
                dot = Container();
              } else {
                List<int> dotIndex = [-1, -1, -1];
                // 해당 날짜에 함께하는 일정이 아니고, 내 일정이 있는 경우 내 점 찍기
                dotIndex[0] = dayEvents.indexWhere((event) =>
                    event.createdBy == _duaryContext.me.value!.getId() &&
                    !event.isTogether);
                // 해당 날짜에 함께하는 일정이 아니고, 상대방 일정이 있는 경우 상대방 점 찍기
                dotIndex[1] = dayEvents.indexWhere((event) =>
                    event.createdBy != _duaryContext.me.value!.getId() &&
                    !event.isTogether);
                // 해당 날짜에 함께하는 일정이 있으면 분홍색 점 찍기
                dotIndex[2] = dayEvents.indexWhere((event) => event.isTogether);

                dotIndex = dotIndex.where((i) => i != -1).toList();
                dot = ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: dotIndex.length,
                  itemBuilder: (context, index) {
                    Event event = dayEvents[dotIndex[index]];
                    if (event.isTogether) {
                      return _CalendarDot(
                          color: Character.together.characterColor);
                    }
                    return _CalendarDot(
                        color: event.member.character!.characterColor);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    width: 3,
                  ),
                );
              }
              // 날짜 그리기
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  widget.onSelectDay(day);
                },
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: DateUtils.isSameDay(day, widget.selectedDay) ? BoxDecoration(
                            color: const Color(0xFFFFEBD1), borderRadius: BorderRadius.circular(99)
                          ) : null,
                          child: Text(
                            "${day.day}",
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF656565)),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                          left: 0,
                          right: 0,
                          child: Center(child: SizedBox(height: 5, child: dot)))
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

class HeightReporter extends StatefulWidget {
  final Widget child;
  final Function(double height) onHeightMeasured;

  const HeightReporter({
    super.key,
    required this.child,
    required this.onHeightMeasured,
  });

  @override
  State<HeightReporter> createState() => _HeightReporterState();
}

class _HeightReporterState extends State<HeightReporter> {
  final GlobalKey _key = GlobalKey();

  @override
  void didUpdateWidget(covariant HeightReporter oldWidget) {
    super.didUpdateWidget(oldWidget);
    _measureHeight();
  }

  void _measureHeight() {
    // 위젯의 렌더링이 끝난 직후에 콜백을 실행하여 높이를 측정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        widget.onHeightMeasured(box.size.height);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}
