
import 'package:duary/widget/duary_timetable.dart';
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

  DateTime focus = DateTime.now();

  late final PageController _pageController;

  late ScrollController _timeTableScrollController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);
    _timeTableScrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("ko_KR");
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        YearCalendar(
          initialMonth: focus,
          onMonthTap: (month) {
            setState(() {
              focus = DateTime(month.year, month.month, focus.day);
              _pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.ease);
            });
          },
        ),
        MonthCalendar(
          initialDate: focus,
          onDateTap: (date) {
            _pageController.animateToPage(2,
                duration: const Duration(milliseconds: 250),
                curve: Curves.ease);
            setState(() {
              focus = date;
            });
          },
          onYearTap: (DateTime year) {
            _pageController.animateToPage(0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.ease);
          },
        ),
        DuaryTimetable(
          initialDate: focus,
          onDateTap: (day) {
            _pageController.animateToPage(1,
                duration: const Duration(milliseconds: 250),
                curve: Curves.ease);
            setState(() {
              focus = day;
            });
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timeTableScrollController.dispose();
    super.dispose();
  }
}
