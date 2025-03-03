import 'package:duary/model/enums/character.dart';
import 'package:duary/model/event.dart';
import 'package:duary/provider/auth_provider.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/screen/edit_event_screen.dart';
import 'package:duary/screen/event_details_screen.dart';
import 'package:duary/support/custom_page_route.dart';
import 'package:duary/widget/bubble_painter.dart';
import 'package:duary/widget/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DuaryTimetable extends StatefulWidget {
  const DuaryTimetable(
      {super.key, required this.onDateTap, required this.initialDate});

  final void Function(DateTime) onDateTap;

  final DateTime initialDate;

  static const double hourHeight = 90;

  @override
  State<DuaryTimetable> createState() => _DuaryTimetableState();
}

class _DuaryTimetableState extends State<DuaryTimetable> {
  late DateTime dayFocus;
  late int dayIndex;
  late final int initialDayIndex;
  late final PagingController<DateTime, List<Event>> _pagingUpController;
  late final PagingController<DateTime, List<Event>> _pagingDownController;
  late ScrollController _scrollController;
  late final EventProvider _eventProvider;
  final AuthProvider _authProvider = AuthProvider();

  // 중복 fetch 를 방지하기 위한 flag
  // 오늘 날짜 index 를 0으로, 내일 index 는 1, 어제 index 는 0
  // if fetchFlag[0] == true, already fetched
  // else if fetchFlag[-2] == null, noy fetched yet
  final Map<int, bool> fetchFlag = {};

  final Key downListKey = UniqueKey();

  static const double hourHeight = DuaryTimetable.hourHeight;
  static const double _timelineLength = 22;

  @override
  void initState() {
    super.initState();

    dayFocus = widget.initialDate;
    initialDayIndex = (dayFocus.difference(DateTime.now()).inHours / 24).ceil();
    dayIndex = initialDayIndex;

    _eventProvider = context.read<EventProvider>();

    _pagingUpController = PagingController(
        firstPageKey: dayFocus.subtract(const Duration(days: 1)));
    _pagingDownController = PagingController(firstPageKey: dayFocus);
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
    // 현재 어느 날짜 블록에 해당하는지 인덱스 구함
    // 예: offset=0~1440px => dayIndex=0 (8/17)
    //     offset=1441~2880px => dayIndex=1 (8/18)
    const double dayBlockHeight = hourHeight * 24;
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

    int index = (offset / dayBlockHeight).floor() + initialDayIndex;

    if (dayIndex != index) {
      dayIndex = index;
      setState(() {
        dayFocus = DateTime.now().add(Duration(days: dayIndex));
      });
    }
  }

  Future<void> _fetchDownPage(DateTime pageKey) async {
    try {
      // 하루동안의 event 불러옴
      DateTime startDate = DateTime(pageKey.year, pageKey.month, pageKey.day);
      DateTime endDate = DateTime(pageKey.year, pageKey.month, pageKey.day + 1);
      final newItems = await _eventProvider.getEvent(startDate, endDate);

      final DateTime nextPageKey = pageKey.add(const Duration(days: 1));

      _pagingDownController.appendPage([newItems], nextPageKey);
    } catch (error) {
      _pagingDownController.error = error;
    }
  }

  Future<void> _fetchUpPage(DateTime pageKey) async {
    try {
      // 하루동안의 event 불러옴
      DateTime startDate = DateTime(pageKey.year, pageKey.month, pageKey.day);
      DateTime endDate = DateTime(pageKey.year, pageKey.month, pageKey.day + 1);
      final newItems = await _eventProvider.getEvent(startDate, endDate);

      final DateTime nextPageKey = pageKey.subtract(const Duration(days: 1));

      _pagingUpController.appendPage([newItems], nextPageKey);
    } catch (error) {
      _pagingUpController.error = error;
    }
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
        SizedBox(height: 100, child: _buildTitleBar()),
        // Two way(up, down) Infinite Scroll View
        Flexible(
          child: Scrollable(
            controller: _scrollController,
            viewportBuilder: (BuildContext context, ViewportOffset position) {
              return Viewport(
                offset: position,
                center: downListKey,
                slivers: [
                  PagedSliverList<DateTime, List<Event>>(
                      nextPageStrategy: () {
                        if (dayIndex < initialDayIndex &&
                            fetchFlag[dayIndex] == null) {
                          fetchFlag[dayIndex] = true;
                          return true;
                        } else {
                          return false;
                        }
                      },
                      pagingController: _pagingUpController,
                      builderDelegate: PagedChildBuilderDelegate(
                          itemBuilder: (context, items, index) => SizedBox(
                                height: hourHeight * 24,
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: LayoutBuilder(
                                        builder: (context, constraints) =>
                                            Stack(
                                          children: _buildBubbles(constraints.maxWidth, items, true),
                                        ),
                                      ),
                                    ),
                                    _buildTimeLines(),
                                    Expanded(child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      return Stack(
                                        children: _buildBubbles(constraints.maxWidth, items, false),
                                      );
                                    })),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ))),
                  PagedSliverList<DateTime, List<Event>>(
                      key: downListKey,
                      nextPageStrategy: () {
                        if (dayIndex >= initialDayIndex &&
                            fetchFlag[dayIndex] == null) {
                          fetchFlag[dayIndex] = true;
                          return true;
                        } else {
                          return false;
                        }
                      },
                      pagingController: _pagingDownController,
                      builderDelegate: PagedChildBuilderDelegate(
                          itemBuilder: (context, items, index) => SizedBox(
                                height: hourHeight * 24,
                                // 60px per hour, 24 hour = 60 * 24 = 1440 px
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: LayoutBuilder(
                                          builder: (context, constraints) {
                                        return Stack(
                                          children: _buildBubbles(constraints.maxWidth, items, true),
                                        );
                                      }),
                                    ),
                                    _buildTimeLines(),
                                    Expanded(
                                        child: LayoutBuilder(
                                      builder: (context, constraints) => Stack(
                                        children: _buildBubbles(constraints.maxWidth, items, false),
                                      ),
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
    );
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

    late Widget titleWidget;

    if (-2 < dayIndex && dayIndex < 2) {
      titleWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
      titleWidget = Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Color(0xFFFE8F00),
            letterSpacing: 0),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: 16,
            child: GestureDetector(
              onTap: () {
                widget.onDateTap(dayFocus);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.chevron_left,
                    size: 24,
                  ),
                  Text(
                    "${dayFocus.month}월",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(SlideDownRoute(page: const EditEventScreen()));
              },
              child: const Icon(
                Icons.add,
                color: Color(0xFFFFAC40),
              ),
            ),
          ),
          Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              titleWidget,
            ],
          )),
        ],
      ),
    );
  }

  List<Widget> _buildBubbles(double maxWidth, List<Event> events, bool isLeft) {
    List<Widget> widgets = [];

    for (int i = 0; i < events.length; i++) {
      Event event = events[i];
      // 이벤트 위치 계산
      double yPosition =
          event.startDateTime.hour * hourHeight + event.startDateTime.minute;
      // 이벤트 높이 계산, 1분 = 1px
      double height =
          event.endDateTime.difference(event.startDateTime).inMinutes *
              hourHeight /
              60.toDouble();

      // 일정 내용
      String time =
          "${DateFormat("hh:mm").format(event.startDateTime)} - ${DateFormat("hh:mm").format(event.endDateTime)}";
      Character character =
          event.isTogether ? Character.together : event.member.character;
      Widget content = Padding(
        padding: isLeft
            ? const EdgeInsets.fromLTRB(16, 8, 29, 8)
            : const EdgeInsets.fromLTRB(29, 8, 16, 8),
        child: Column(
          crossAxisAlignment:
              isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(
                  color: character.fontColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              event.title,
              textAlign: isLeft ? TextAlign.end : null,
              style: TextStyle(
                  color: character.fontBlackColor,
                  fontSize: 13,
                  height: 1.1,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );

      // 캐릭터
      late Widget characterImage;
      if (event.isTogether) {
        if (isLeft) {
          characterImage = const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Yellow(
                width: 39,
                height: 39,
                opacity: 0.2,
              ),
              Blue(
                width: 39,
                height: 67,
                opacity: 0.2,
              ),
            ],
          );
        } else {
          characterImage = const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Blue(
                width: 39,
                height: 67,
                opacity: 0.2,
              ),
              Yellow(
                width: 39,
                height: 39,
                opacity: 0.2,
              ),
            ],
          );
        }
      } else if (event.member.character == Character.blue) {
        characterImage = const Blue(
          width: 39,
          height: 67,
          opacity: 0.2,
        );
      } else {
        characterImage = const Yellow(
          width: 39,
          height: 39,
          opacity: 0.2,
        );
      }

      // draw bubble
      late Widget bubble;
      if (event.isTogether) {
        if (isLeft) {
          bubble = SizedBox(
            height: height,
            child: CustomPaint(
              painter: SpeechBubblePainter(isLeft: isLeft, character: character),
              child: ClipPath(
                clipper: RightBottomRoundedClipper(),
                child: Stack(
                  children: [
                    content,
                    Positioned(bottom: -21, right: 13, child: characterImage)
                  ],
                ),
              ),
            ),
          );
        } else {
          bubble = SizedBox(
            height: height,
            child: CustomPaint(
              painter: SpeechBubblePainter(isLeft: isLeft, character: character),
              child: ClipPath(
                clipper: RightBottomRoundedClipper(),
                child: Stack(
                  children: [
                    content,
                    Positioned(bottom: -21, left: 13, child: characterImage)
                  ],
                ),
              ),
            ),
          );
        }
      } else if (isLeft &&
          event.member.socialId == _authProvider.me!.socialId) {
        bubble = SizedBox(
          height: height,
          child: CustomPaint(
            painter: SpeechBubblePainter(isLeft: isLeft, character: character),
            child: ClipPath(
              clipper: RightBottomRoundedClipper(),
              child: Stack(
                children: [
                  content,
                  Positioned(bottom: -21, right: 13, child: characterImage)
                ],
              ),
            ),
          ),
        );
      } else if (!isLeft &&
          event.member.socialId != _authProvider.me!.socialId) {
        bubble = SizedBox(
          height: height,
          child: CustomPaint(
            painter: SpeechBubblePainter(isLeft: isLeft, character: character),
            child: ClipPath(
              clipper: LeftBottomRoundedClipper(),
              child: Stack(
                children: [
                  content,
                  Positioned(bottom: -21, left: 13, child: characterImage)
                ],
              ),
            ),
          ),
        );
      } else {
        continue;
      }
      widgets.add(Positioned(
        left: 0,
        right: 0,
        top: yPosition,
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventDetailsScreen(event: event)));
            },
            child: bubble),
      ));
    }
    return widgets;
  }

  Widget _buildTimeLines() {
    return Column(
      children: List.generate(24, (index) {
        return Container(
          color: const Color(0xFFFBFBFB),
          width: _timelineLength,
          height: hourHeight,
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

  @override
  void dispose() {
    super.dispose();
    _pagingDownController.dispose();
    _pagingUpController.dispose();
  }
}
