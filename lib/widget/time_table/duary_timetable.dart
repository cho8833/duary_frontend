import 'dart:math' as Math show min;

import 'package:duary/model/event.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/screen/timetable_screen.dart';
import 'package:duary/widget/time_table/day_view.dart';
import 'package:duary/widget/time_table/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' show Fluttertoast;
import 'package:provider/provider.dart';

class DuaryTimetable extends StatefulWidget {
  const DuaryTimetable({
    super.key,
    required this.timeTableController,
  });

  final TimeTableController timeTableController;

  static const double hourHeight = 90;

  static const double timelineLength = 22;

  @override
  State<DuaryTimetable> createState() => _DuaryTimetableState();
}

class _DuaryTimetableState extends State<DuaryTimetable> {
  late final TimeTableController _timeTableController =
      widget.timeTableController;

  late final DateTime initialDay = _timeTableController.focusDay.value;
  late DateTime dayFocus = initialDay;

  List<Event> events = [];

  late final ScrollController _scrollController = ScrollController();

  late final EventProvider _eventProvider = context.read<EventProvider>();

  final DuaryContext duaryContext = DuaryContext();

  // 충분히 큰 초기 페이지를 지정해서, 양쪽 방향으로 스와이프 가능하게 함.
  static const _totalPage = 500;
  static const _initialPage = 250;
  late final PageController _pageController =
      PageController(initialPage: _initialPage);

  late double layoutBuilderHeight;

  final GlobalKey tableFlexibleKey = GlobalKey();


  @override
  void initState() {
    super.initState();

    // Events 초기화
    _eventProvider.getEventByDay(dayFocus).then((list) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          events = list;
        });
      });
    });

    // DayFocus 가 오늘인 경우 현재 시간으로 스크롤 위치 이동
    if (DateUtils.isSameDay(dayFocus, DateTime.now())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DateTime now = DateTime.now();
        // _scrollController.jumpTo(now.hour * DuaryTimetable.hourHeight);
        // 위 코드는 스크롤 맨 하단을 벗어나 jump 를 시도(overscroll) 하기 때문에, 튕겨져 올라옴
        // SingleChildScrollView   구조에서, LayoutBuilder.constraints.maxHeight 는 2160(DuaryTimetable.hourHeight * 24) 이고,
        //      ㄴ LayoutBuilder           SingleChildScrollView 의 height 를 구하면 화면의 맨 하단부터 title bar 까지의 거리가 나온다.
        // 따라서, min(now.hour * DuaryTimeTable.hourHeight, LayoutBuilder.constraints.maxHeight - SingleChildScrollView.height)
        // 를 통해 튕겨저 올라오는 것을 방지한다.
        // - 20 은 여유 값
        double attempt = now.hour * DuaryTimetable.hourHeight;
        double max = DuaryTimetable.hourHeight * 24 - _getScrollViewHeight() - 20;
        double value = Math.min(attempt, max);
        _scrollController.jumpTo(value);
      });
    }

    _eventProvider.addListener(getEvents);
    // 유저 정보나 커플 정보가 바뀌면 다시 event 불러오기
    duaryContext.me.addListener(getEvents);
    duaryContext.lover.addListener(getEvents);
    duaryContext.myCouple.addListener(getEvents);
  }

  @override
  void dispose() {
    super.dispose();
    _eventProvider.removeListener(getEvents);
    duaryContext.me.removeListener(getEvents);
    duaryContext.lover.removeListener(getEvents);
    duaryContext.myCouple.removeListener(getEvents);
  }

  double _getScrollViewHeight() {
    final RenderBox renderBox = tableFlexibleKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  void getEvents() {
    _eventProvider.getEventByDay(dayFocus).then((list) {
      setState(() {
        events = list;
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 16,
        ),
        TitleBar(
          dayFocus: dayFocus,
          events: events,
          onDateTap: () => _timeTableController.moveToMonth(dayFocus),
        ),
        Flexible(
          key: tableFlexibleKey,
          child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  dayFocus = initialDay
                      .add(Duration(days: index - _initialPage));
                });
                getEvents();
              },
              controller: _pageController,
              itemCount: _totalPage,
              itemBuilder: (context, index) {
                DateTime currentDate = initialDay
                    .add(Duration(days: index - _initialPage));
                return SingleChildScrollView(
                    controller: _scrollController,
                    child: LayoutBuilder(// width 전달 목적
                        builder: (context, constraints) {
                      return DayView(
                        currentDate: currentDate,
                        items: events,
                        width: constraints.maxWidth,
                      );
                    }));
              }),
        ),
      ],
    );
  }
}
