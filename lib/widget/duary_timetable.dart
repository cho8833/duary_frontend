import 'package:duary/model/enums/character.dart';
import 'package:duary/model/event.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/screen/edit_event_screen.dart';
import 'package:duary/screen/event_details_screen.dart';
import 'package:duary/support/custom_page_route.dart';
import 'package:duary/widget/character_widget.dart';
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

  // 중복 fetch 를 방지하기 위한 flag
  // 오늘 날짜 index 를 0으로, 내일 index 는 1, 어제 index 는 -1
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

  @override
  void dispose() {
    super.dispose();
    _pagingDownController.dispose();
    _pagingUpController.dispose();
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
      final newItems = await _eventProvider.getEventByDay(startDate);

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
      final newItems = await _eventProvider.getEventByDay(startDate);

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
                          itemBuilder: (context, items, index) => _BubbleSection(items: items),
                          firstPageErrorIndicatorBuilder: (context) {
                            return const Center(
                              child: Text("일정을 불러오는 데에 실패했습니다"),
                            );
                          })),
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
                          itemBuilder: (context, items, index) => _BubbleSection(items: items),
                          firstPageErrorIndicatorBuilder: (context) {
                            return const Center(
                              child: Text("일정을 불러오는 데에 실패했습니다"),
                            );
                          })),
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
}

class _BubbleSection extends StatefulWidget {
  const _BubbleSection({required this.items});

  final List<Event> items;

  @override
  State<_BubbleSection> createState() => _BubbleSectionState();
}

class _BubbleSectionState extends State<_BubbleSection> {
  final DuaryContext _duaryContext = DuaryContext();

  static const hourHeight = _DuaryTimetableState.hourHeight;
  static const _timelineLength = _DuaryTimetableState._timelineLength;

  late final List<Event> items;

  @override
  void initState() {
    items = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hourHeight * 24,
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: _buildBubbles(constraints.maxWidth, items, true),
                );
              })),
          _buildTimeLines(),
          Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: _buildBubbles(constraints.maxWidth, items, false),
                );
              })),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLines() {
    return Column(
      children: List.generate(24, (index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
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

  List<Widget> _buildBubbles(double maxWidth, List<Event> events, bool isLeft) {
    List<Widget> widgets = [];

    List<List<Event>> overlapGrouped =
        groupOverlappingEvents(events, isMine: isLeft);

    for (final List<Event> overlapEvents in overlapGrouped) {
      int overlapCount = overlapEvents.length;

      for (int i = 0; i < overlapCount; i++) {
        Event event = overlapEvents[i];
        // 이벤트 위치 계산
        double yPosition = event.startDateTime.hour * hourHeight +
            (event.startDateTime.minute * 3 / 2);
        double xPosition = isLeft ? i * 20 : (overlapCount - i - 1) * 20;

        // 이벤트 높이 계산, 1분 = 1px
        double height =
            event.endDateTime.difference(event.startDateTime).inMinutes *
                hourHeight /
                60.toDouble();

        // 이벤트 너비 계산
        double width = maxWidth - (overlapCount - 1) * 20;

        Widget? bubble = _buildBubble(event, isLeft, width, height);
        if (bubble != null) {
          double left = xPosition;
          widgets.add(Positioned(
            left: left,
            top: yPosition,
            child: GestureDetector(
                onTap: () {
                  int zIndex = items.indexOf(event);
                  // Bubble 이 맨 위로 올라와 있지 않으면 맨 위로 올림
                  if (zIndex != items.length -1) {
                    setState(() {
                      items.remove(event);
                      items.add(event);
                    });
                    // Bubble 이 맨 위로 올라와 있으면 Detail Screen 으로 route
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EventDetailsScreen(event: event)));
                  }
                },
                child: bubble),
          ));
        }
      }
    }

    return widgets;
  }

  Widget? _buildBubble(Event event, bool isLeft, double width, double height) {
    // 일정 내용
    String time =
        "${DateFormat("hh:mm").format(event.startDateTime)} - ${DateFormat("hh:mm").format(event.endDateTime)}";
    Character character =
        event.isTogether ? Character.together : event.member.character!;

    Widget content = Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            textAlign: TextAlign.start,
            style: TextStyle(
                color: character.fontBlackColor,
                fontSize: 13,
                height: 1.1,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    return _Bubble(
      character: character,
      width: width,
      height: height,
      isLeft: isLeft,
      content: content,
    );
  }

  List<List<Event>> groupOverlappingEvents(List<Event> events,
      {required bool isMine}) {
    const int maxTime = 1440;
    final List<List<Event>> startEvents = List.generate(maxTime + 2, (_) => []);
    final List<List<Event>> endEvents = List.generate(maxTime + 2, (_) => []);

    List<Event> filtered = events.where((event) {
      if (isMine) {
        return _duaryContext.me.value!.getId() == event.member.getId() ||
            event.isTogether;
      } else {
        return _duaryContext.me.value!.getId() != event.member.getId() ||
            event.isTogether;
      }
    }).toList();

    // ID -> index 맵으로 원래 정렬 순서 추적
    final Map<String, int> eventOrder = {
      for (int i = 0; i < filtered.length; i++) filtered[i].id: i
    };

    for (final event in filtered) {
      int start = event.startDateTime.hour * 60 + event.startDateTime.minute;
      int end = event.endDateTime.hour * 60 + event.endDateTime.minute;
      startEvents[start].add(event);
      endEvents[end].add(event);
    }

    final Set<Event> activeEvents = <Event>{};
    final Map<String, Set<String>> overlaps = {
      for (var event in filtered) event.id: <String>{},
    };

    for (int minute = 0; minute <= maxTime; minute++) {
      for (final event in startEvents[minute]) {
        for (final activeEvent in activeEvents) {
          overlaps[event.id]!.add(activeEvent.id);
          overlaps[activeEvent.id]!.add(event.id);
        }
        activeEvents.add(event);
      }

      for (final event in endEvents[minute]) {
        activeEvents.remove(event);
      }
    }

    final Set<String> visited = <String>{};
    final List<List<Event>> result = [];
    final Map<String, Event> eventById = {
      for (Event event in filtered) event.id: event
    };

    for (final event in filtered) {
      if (!visited.contains(event.id)) {
        final List<String> queue = [event.id];
        final Set<String> groupIds = <String>{};

        while (queue.isNotEmpty) {
          final String current = queue.removeLast();
          if (visited.contains(current)) continue;

          visited.add(current);
          groupIds.add(current);

          // queue에 추가할 때 정렬된 순서 기준으로 우선순위 지정
          final neighbors = overlaps[current]!.toList()
            ..sort((a, b) => eventOrder[a]!.compareTo(eventOrder[b]!));

          for (final neighbor in neighbors) {
            if (!visited.contains(neighbor)) {
              queue.add(neighbor);
            }
          }
        }

        // 그룹 내부도 입력 순서 유지
        final group = groupIds
            .map((id) => eventById[id]!)
            .toList()
          ..sort((a, b) =>
              eventOrder[a.id]!.compareTo(eventOrder[b.id]!));

        result.add(group);
      }
    }

    return result;
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble(
      {super.key,
      required this.character,
      required this.width,
      required this.height,
      required this.isLeft,
      required this.content});

  final double width;

  final double height;

  final Character character;

  final Widget content;

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: character.bubbleColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(2, 2))
          ]),
      child: ClipPath(
        clipper: RoundedClipper(),
        child: Stack(
          children: [
            content,
            Positioned(
                bottom: -21,
                right: isLeft ? 5 : null,
                left: isLeft ? null : 5,
                child: _CharacterImage(
                    isTogether: character == Character.together,
                    isLeft: isLeft,
                    character: character))
          ],
        ),
      ),
    );
  }
}

class _CharacterImage extends StatelessWidget {
  const _CharacterImage(
      {required this.isTogether,
      required this.isLeft,
      required this.character});

  final bool isTogether;

  final bool isLeft;

  final Character character;

  @override
  Widget build(BuildContext context) {
    if (isTogether) {
      if (isLeft) {
        return const Row(
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
        return const Row(
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
    } else if (character == Character.blue) {
      return const Blue(
        width: 39,
        height: 67,
        opacity: 0.2,
      );
    } else {
      return const Yellow(
        width: 39,
        height: 39,
        opacity: 0.2,
      );
    }
  }
}

class RoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 20;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    return Path()..addRRect(rRect);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
