import 'dart:async';

import 'package:duary/model/enums/character.dart';
import 'package:duary/model/event.dart';
import 'package:duary/provider/auth_provider.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/screen/edit_event_screen.dart';
import 'package:duary/widget/bubble_painter.dart';
import 'package:duary/widget/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  DateTime dayFocus = DateTime.now();
  int dayIndex = 0;
  late final PagingController<DateTime, List<Event>> _pagingUpController;
  late final PagingController<DateTime, List<Event>> _pagingDownController;
  late final ScrollController _scrollController;
  late final EventProvider _eventProvider;
  final AuthProvider _authProvider = AuthProvider();

  // 중복 fetch 를 방지하기 위한 flag
  // 오늘 날짜 index 를 0으로, 내일 index 는 1, 어제 index 는 0
  // if fetchFlag[0] == true, already fetched
  // else if fetchFlag[-2] == null, noy fetched yet
  final Map<int, bool> fetchFlag = {};

  final Key downListKey = UniqueKey();

  static const double _hourHeight = 60;
  static const double _timelineLength = 22;

  @override
  void initState() {
    super.initState();

    _eventProvider = context.read<EventProvider>();

    _pagingUpController = PagingController(
        firstPageKey: DateTime.now().subtract(const Duration(days: 1)));
    _pagingDownController = PagingController(firstPageKey: DateTime.now());
    _pagingUpController.addPageRequestListener((pageKey) {
      _fetchUpPage(pageKey);
    });
    _pagingDownController.addPageRequestListener((pageKey) {
      _fetchDownPage(pageKey);
    });

    // 초기 로딩 시 firstPageKey 에 대한 데이터를 fetch 하기 때문에 해당 Flag 세움
    fetchFlag[0] = true;
    fetchFlag[-1] = true;

    _scrollController = ScrollController();
    _scrollController.addListener(updateDayIndex);
  }

  String _formatDate(DateTime date) {
    return "${DateFormat("yyyy년 M월 dd일").format(dayFocus)} ${DateFormat.E("ko_KR").format(dayFocus)}요일";
  }

  void updateDayIndex() {
    int index = getCurrentDateIndex();

    if (dayIndex != index) {
      dayIndex = index;
      setState(() {
        dayFocus = DateTime.now().add(Duration(days: dayIndex));
      });
    }
  }

  // 현재 어느 날짜 블록에 해당하는지 인덱스 구함
  // 예: offset=0~1440px => dayIndex=0 (8/17)
  //     offset=1441~2880px => dayIndex=1 (8/18)
  int getCurrentDateIndex() {
    const double dayBlockHeight = _hourHeight * 24;
    late final double offset;

    // 위로 스크롤 중이면 화면 상단을 기준으로 어느 날짜 블록에 있는지 계산
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      offset = _scrollController.offset;
    }
    // 아래로 스크롤 중이면 화면 하단을 기준으로 어느 날짜 블록에 있는지 계산
    else {
      offset = _scrollController.offset +
          _scrollController.position.viewportDimension;
    }

    return (offset / dayBlockHeight).floor();
  }

  Future<void> _fetchDownPage(DateTime pageKey) async {
    try {
      final newItems = await _eventProvider.getEvent(pageKey);

      final DateTime nextPageKey = pageKey.add(const Duration(days: 1));

      _pagingDownController.appendPage([newItems], nextPageKey);
    } catch (error) {
      _pagingDownController.error = error;
    }
  }

  Future<void> _fetchUpPage(DateTime pageKey) async {
    try {
      final newItems = await _eventProvider.getEvent(pageKey);

      final DateTime nextPageKey = pageKey.subtract(const Duration(days: 1));

      _pagingUpController.appendPage([newItems], nextPageKey);
    } catch (error) {
      _pagingUpController.error = error;
    }
  }

  Widget _buildTitleBar() {
    late String title;

    switch (dayIndex) {
      case 0:
        title = "오늘";
      case 1:
        title = "내일";
      case -1:
        title = "어제";
      default:
        title = _formatDate(dayFocus);
    }

    if (-2 < dayIndex && dayIndex < 2) {
      return Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Color(0xFFFE8F00)),
          ),
          Text(
            _formatDate(dayFocus),
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: Color(0xFF969696)),
          ),
        ],
      );
    } else {
      return Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Color(0xFFFE8F00)),
      );
    }
  }

  // Widget _buildAllDay() {
  //
  // }

  Widget _buildTimeLines() {
    return Column(
      children: List.generate(24, (index) {
        return Container(
          color: const Color(0xFFFBFBFB),
          width: _timelineLength,
          height: _hourHeight,
          child: SizedBox(
            child: Text(
              index.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF858585)),
            ),
          ),
        );
      }),
    );
  }

  List<Widget> _buildBubbles(
      BuildContext context, List<Event> events, bool isMine) {
    List<Widget> widgets = [];

    for (int i = 0; i < events.length; i++) {
      Event event = events[i];
      // 이벤트 위치 계산
      double yPosition =
          event.startDateTime.hour * _hourHeight + event.startDateTime.minute;
      // 이벤트 높이 계산, 1분 = 1px
      double height = event.endDateTime
          .difference(event.startDateTime)
          .inMinutes
          .toDouble();

      // 일정 내용
      String time =
          "${DateFormat("hh:mm").format(event.startDateTime)} - ${DateFormat("hh:mm").format(event.endDateTime)}";
      Widget content = Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyle(
                  color: event.member.character.fontColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              event.title,
              style: TextStyle(
                  color: event.member.character.fontBlackColor,
                  fontSize: 13,
                  height: 1.1,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 4,
            ),
            event.location != null ? Text(event.location!) : Container()
          ],
        ),
      );

      // 캐릭터
      late Widget character;
      if (event.member.character == Character.blue) {
        character = const Blue(
          width: 39,
          height: 67,
          opacity: 0.2,
        );
      } else {
        character = const Yellow(
          width: 39,
          height: 39,
          opacity: 0.2,
        );
      }

      // draw bubble
      late Widget bubble;
      if (isMine && event.member.socialId == _authProvider.me!.socialId) {
        bubble = Positioned(
          top: yPosition,
          left: 0,
          right: 0,
          child: SizedBox(
            height: height,
            child: CustomPaint(
              painter: SpeechBubblePainter(
                  isLeft: false, character: event.member.character),
              child: ClipPath(
                clipper: RightBottomRoundedClipper(),
                child: Stack(
                  children: [
                    content,
                    Positioned(bottom: -21, right: 13, child: character)
                  ],
                ),
              ),
            ),
          ),
        );
        widgets.add(bubble);
      } else if (!isMine &&
          event.member.socialId != _authProvider.me!.socialId) {
        bubble = Positioned(
          left: 0,
          right: 0,
          top: yPosition,
          child: SizedBox(
            height: height,
            child: CustomPaint(
              painter: SpeechBubblePainter(
                  isLeft: true, character: event.member.character),
              child: ClipPath(
                clipper: LeftBottomRoundedClipper(),
                child: Stack(
                  children: [
                    content,
                    Positioned(bottom: -21, left: 13, child: character)
                  ],
                ),
              ),
            ),
          ),
        );
        widgets.add(bubble);
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("ko_KR");
    return Stack(
      children: [
        Positioned(
          right: 16,
          top: 16,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditEventScreen()));
            },
            child: const Icon(
              Icons.add,
              color: Color(0xFFFFAC40),
            ),
          ),
        ),
        Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 16,
                ),
                _buildTitleBar(),
              ],
            ),
            // Two way(up, down) Infinite Scroll View
            Expanded(
              child: Scrollable(
                controller: _scrollController,
                viewportBuilder:
                    (BuildContext context, ViewportOffset position) {
                  return Viewport(
                    offset: position,
                    center: downListKey,
                    slivers: [
                      PagedSliverList<DateTime, List<Event>>(
                          nextPageStrategy: () {
                            if (dayIndex < 0 && fetchFlag[dayIndex] == null) {
                              fetchFlag[dayIndex] = true;
                              return true;
                            } else {
                              return false;
                            }
                          },
                          pagingController: _pagingUpController,
                          builderDelegate: PagedChildBuilderDelegate(
                              itemBuilder: (context, items, index) => SizedBox(
                                    height: 1440,
                                    // 60px per hour, 24 hour = 60 * 24 = 1440 px
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Stack(
                                            children: _buildBubbles(
                                                context, items, true),
                                          ),
                                        ),
                                        _buildTimeLines(),
                                        Expanded(
                                            child: Stack(
                                          children: _buildBubbles(
                                              context, items, false),
                                        )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ))),
                      PagedSliverList<DateTime, List<Event>>(
                          key: downListKey,
                          nextPageStrategy: () {
                            if (dayIndex >= 0 && fetchFlag[dayIndex] == null) {
                              fetchFlag[dayIndex] = true;
                              return true;
                            } else {
                              return false;
                            }
                          },
                          pagingController: _pagingDownController,
                          builderDelegate: PagedChildBuilderDelegate(
                              itemBuilder: (context, items, index) => SizedBox(
                                    height: 1440,
                                    // 60px per hour, 24 hour = 60 * 24 = 1440 px
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Stack(
                                            children: _buildBubbles(
                                                context, items, true),
                                          ),
                                        ),
                                        _buildTimeLines(),
                                        Expanded(
                                            child: Stack(
                                          children: _buildBubbles(
                                              context, items, false),
                                        )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ))),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pagingDownController.dispose();
    _pagingUpController.dispose();
    super.dispose();
  }
}
