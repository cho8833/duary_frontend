import 'package:duary/widget/time_table/duary_timetable.dart';
import 'package:duary/widget/month_calendar.dart';
import 'package:duary/widget/year_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({
    super.key,
  });

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {

  DateTime focusDay  = DateUtils.dateOnly(DateTime.now());
  late DateTime focusYear = focusDay;
  late DateTime focusMonth = focusDay;

  late final PageController _pageController = PageController(initialPage: 2);
  late final TimeTableController _timeTableController = TimeTableController(_pageController);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("ko_KR");
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        YearCalendar(
          timeTableController: _timeTableController,
        ),
        MonthCalendar(
          timeTableController: _timeTableController,
        ),
        DuaryTimetable(
          timeTableController: _timeTableController,
        )
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class TimeTableController {
  ValueNotifier<DateTime> focusDay = ValueNotifier(DateUtils.dateOnly(DateTime.now()));
  late ValueNotifier<DateTime> focusYear = ValueNotifier(focusDay.value);
  late ValueNotifier<DateTime> focusMonth = ValueNotifier(focusDay.value);

  final PageController _pageController;

  TimeTableController(this._pageController);

  void moveToYear(DateTime year) {
    focusYear.value = year;
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease);
  }
  void moveToMonth(DateTime month) {
    focusMonth.value = month;
    _pageController.animateToPage(1, duration: const Duration(milliseconds: 250), curve: Curves.ease);
  }
  void moveToDay(DateTime day) {
    focusDay.value = day;
    _pageController.animateToPage(2, duration: const Duration(milliseconds: 250), curve: Curves.ease);
  }

}