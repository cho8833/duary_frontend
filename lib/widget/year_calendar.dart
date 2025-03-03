import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class YearCalendar extends StatefulWidget {
  const YearCalendar(
      {super.key, required this.initialMonth, required this.onMonthTap});

  final DateTime initialMonth;
  final void Function(DateTime) onMonthTap;

  @override
  State<YearCalendar> createState() => _YearCalendarState();
}

class _YearCalendarState extends State<YearCalendar> {
  late DateTime focusYear;
  late final PageController _pageController;
  static const _totalPage = 500;
  static const _initialPage = 250;

  @override
  void initState() {
    super.initState();
    focusYear = widget.initialMonth;
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: PageView.builder(
          controller: _pageController,
          itemCount: _totalPage,
          onPageChanged: (index) {
            setState(() {
              // index와 initialPage의 차이를 이용해 현재 페이지의 년을 계산
              final int yearOffset = index - _initialPage;
              focusYear = DateTime(
                widget.initialMonth.year + yearOffset,
                1,
              );
            });
          },
          itemBuilder: (context, index) {
            return Column(
              children: [
                Text(
                  "${focusYear.year}년",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFE8F00)),
                ),
                const SizedBox(height: 12),
                // 12개월을 3열로 배치 (3×4=12)
                AlignedGridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  itemCount: 12,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 12,
                  itemBuilder: (context, index) {
                    final int month = index + 1;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        DateTime tapped = DateTime(
                          focusYear.year,
                          month,
                        );
                        widget.onMonthTap(tapped);
                      },
                      child: SingleMonthWidget(
                        year: 2025,
                        month: month,
                      ),
                    );
                  },
                ),
              ],
            );
          }),
    );
  }
}

class SingleMonthWidget extends StatelessWidget {
  final int year;
  final int month;

  const SingleMonthWidget({
    super.key,
    required this.year,
    required this.month,
  });

  static const double _dayHeight = 14;

  @override
  Widget build(BuildContext context) {
    // 달 이름
    final String monthName = "$month월";
    // 해당 월의 날짜들을 주 단위(2차원)로 생성
    final weeks = _generateDaysForMonth(year, month);

    return Column(
      children: [
        // 월 이름
        Text(
          monthName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        // 날짜 테이블
        _buildCalendarBody(weeks),
      ],
    );
  }

  // 달력 테이블
  Widget _buildCalendarBody(List<List<DateTime?>> weeks) {
    return Table(
      children: weeks.map((week) {
        return TableRow(
          children: week.map((day) {
            if (day == null) {
              // 다른 달에 속하는 빈 칸
              return const SizedBox(height: _dayHeight);
            } else {
              // 요일에 따라 색상 지정
              Color textColor = Colors.black87;
              if (day.weekday == DateTime.sunday) {
                textColor = const Color(0xFFF22424);
              } else if (day.weekday == DateTime.saturday) {
                textColor = const Color(0xFF4058F9);
              }
              return Container(
                height: _dayHeight,
                alignment: Alignment.center,
                child: Text(
                  "${day.day}",
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              );
            }
          }).toList(),
        );
      }).toList(),
    );
  }

  /// 연/월에 해당하는 날짜들을 "주 단위" 2차원 리스트로 생성
  ///
  /// 예: [[null, null, 1, 2, 3, 4, 5],
  ///      [6, 7, 8, 9, 10, 11, 12],
  ///      ...]
  List<List<DateTime?>> _generateDaysForMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay =
        DateTime(year, month + 1, 1).subtract(const Duration(days: 1));
    final daysInMonth = lastDay.day;

    // Dart에서 weekday: 월(1) ~ 일(7)
    // 일요일을 0으로 보정해서, 테이블의 첫 칸에 일요일을 위치시키려면:
    final startingWeekday = firstDay.weekday % 7;

    List<List<DateTime?>> weeks = [];
    List<DateTime?> currentWeek = [];

    // 첫 주 앞쪽 빈 칸
    for (int i = 0; i < startingWeekday; i++) {
      currentWeek.add(null);
    }

    // 1일부터 마지막 일까지
    for (int day = 1; day <= daysInMonth; day++) {
      currentWeek.add(DateTime(year, month, day));
      if (currentWeek.length == 7) {
        weeks.add(currentWeek);
        currentWeek = [];
      }
    }

    // 남은 칸 채우기
    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        currentWeek.add(null);
      }
      weeks.add(currentWeek);
    }

    return weeks;
  }
}
