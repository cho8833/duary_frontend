import 'dart:ui' as ui;

import 'package:duary/screen/timetable_screen.dart';
import 'package:flutter/material.dart';
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart"
    show AlignedGridView;

class YearCalendar extends StatefulWidget {
  const YearCalendar({super.key, required this.timeTableController});

  final TimeTableController timeTableController;

  @override
  State<YearCalendar> createState() => _YearCalendarState();
}

class _YearCalendarState extends State<YearCalendar> {
  static const _totalPage = 500;
  static const _initialPage = 250;
  late final PageController _pageController =
      PageController(initialPage: _initialPage);

  late final TimeTableController _timeTableController =
      widget.timeTableController;
  late DateTime initialYear = _timeTableController.focusYear.value;

  @override
  void initState() {
    super.initState();
    _timeTableController.focusYear.addListener(yearListener);
  }

  void yearListener() {
    setState(() {
      initialYear = _timeTableController.focusYear.value;
    });
  }

  @override
  void dispose() {
    _timeTableController.focusYear.removeListener(yearListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: PageView.builder(
          controller: _pageController,
          itemCount: _totalPage,
          itemBuilder: (context, index) {
            final int yearOffset = index - _initialPage;
            final focusYear = DateTime(
              initialYear.year + yearOffset,
              1,
            );
            return _YearPage(
                key: ValueKey(focusYear.year),
                year: focusYear.year,
                onMonthTap: _timeTableController.moveToMonth);
          }),
    );
  }
}

class _YearPage extends StatefulWidget {
  const _YearPage({super.key, required this.year, required this.onMonthTap});

  final int year;
  final void Function(DateTime) onMonthTap;

  @override
  State<_YearPage> createState() => _YearPageState();
}

class _YearPageState extends State<_YearPage>
    with AutomaticKeepAliveClientMixin {
  // build 메서드가 다시 호출되어도 상태가 유지되도록
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${widget.year}년",
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFE8F00)),
        ),
        const SizedBox(height: 12),
        // 12개월을 3열로 배치 (3×4=12)
        AlignedGridView.count(
          physics: const NeverScrollableScrollPhysics(),
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
                  widget.year,
                  month,
                );
                widget.onMonthTap(tapped);
              },
              child: SingleMonthWidget(
                key: ValueKey("${widget.year}-month"),
                year: 2025,
                month: month,
              ),
            );
          },
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    // AspectRatio를 사용하여 위젯의 비율을 강제할 수 있습니다.
    // 이는 월별 달력의 모양을 일정하게 유지하는 데 도움이 됩니다.
    return AspectRatio(
      aspectRatio: 1.0, // 가로:세로 비율을 1:1로 설정 (정사각형 모양)
      child: CustomPaint(
        // key를 전달하여 painter가 필요할 때 재생성되도록 할 수 있습니다.
        painter: SingleMonthPainter(
          year: year,
          month: month,
          context: context,
        ),
      ),
    );
  }
}

class SingleMonthPainter extends CustomPainter {
  final int year;
  final int month;
  final BuildContext context; // context는 TextPainter의 textDirection을 위해 필요합니다.

  final List<List<DateTime?>> _weeks;

  SingleMonthPainter({
    required this.year,
    required this.month,
    required this.context,
  }) : _weeks = _generateDaysForMonth(year, month);

  // 이 함수는 외부 헬퍼 함수로 두거나 static으로 만들어도 좋습니다.
  static List<List<DateTime?>> _generateDaysForMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    final daysInMonth = lastDay.day;
    final startingWeekday = firstDay.weekday % 7;

    List<List<DateTime?>> weeks = [];
    List<DateTime?> currentWeek = List.filled(7, null, growable: false);
    int dayIndex = startingWeekday;

    for (int day = 1; day <= daysInMonth; day++) {
      currentWeek[dayIndex] = DateTime(year, month, day);
      dayIndex++;
      if (dayIndex == 7) {
        weeks.add(List.from(currentWeek));
        currentWeek = List.filled(7, null, growable: false);
        dayIndex = 0;
      }
    }

    if (dayIndex > 0) {
      weeks.add(currentWeek);
    }
    return weeks;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // ---- 1. 레이아웃 계산 ----
    final double monthHeaderHeight = size.height * 0.25; // 월 헤더 높이 (전체 높이의 25%)
    final double gridHeight = size.height - monthHeaderHeight;
    final double cellWidth = size.width / 7;
    final double cellHeight =
        _weeks.isNotEmpty ? gridHeight / _weeks.length : 0;

    // ---- 2. 월(Month) 그리기 ----
    _drawText(
      canvas,
      size,
      "$month월",
      Offset(size.width / 2, monthHeaderHeight / 2),
      const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );

    // ---- 3. 날짜(Days) 그리기 ----
    if (cellHeight <= 0) return; // 그릴 공간이 없으면 종료

    for (int i = 0; i < _weeks.length; i++) {
      final week = _weeks[i];
      for (int j = 0; j < week.length; j++) {
        final day = week[j];
        if (day != null) {
          // 요일에 따른 색상 결정
          Color textColor = Colors.black87;
          if (day.weekday == DateTime.sunday) {
            textColor = const Color(0xFFF22424);
          } else if (day.weekday == DateTime.saturday) {
            textColor = const Color(0xFF4058F9);
          }

          // 텍스트 위치 계산
          final dx = cellWidth * j + cellWidth / 2;
          final dy = monthHeaderHeight + cellHeight * i + cellHeight / 2;

          _drawText(
            canvas,
            size,
            day.day.toString(),
            Offset(dx, dy),
            TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          );
        }
      }
    }
  }

  // 텍스트를 중앙에 그리는 헬퍼 함수
  void _drawText(
      Canvas canvas, Size size, String text, Offset offset, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);

    // 텍스트를 중앙 정렬하기 위해 오프셋 조정
    final textOffset = Offset(
      offset.dx - textPainter.width / 2,
      offset.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant SingleMonthPainter oldDelegate) {
    // 년, 월이 변경될 때만 다시 그림
    return oldDelegate.year != year ||
        oldDelegate.month != month ||
        oldDelegate.context != context;
  }
}
