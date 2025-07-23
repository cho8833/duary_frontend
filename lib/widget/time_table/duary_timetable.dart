import 'package:duary/model/event.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/widget/time_table/day_view.dart';
import 'package:duary/widget/time_table/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class DuaryTimetable extends StatefulWidget {
  const DuaryTimetable(
      {super.key, required this.onDateTap, required this.initialDate});

  final void Function(DateTime) onDateTap;

  final DateTime initialDate;

  static const double hourHeight = 90;

  static const double timelineLength = 22;

  @override
  State<DuaryTimetable> createState() => _DuaryTimetableState();
}

class _DuaryTimetableState extends State<DuaryTimetable> {
  late DateTime dayFocus;
  late int dayIndex;
  late int initialDayIndex;

  late final PagingController<DateTime, Map<DateTime, List<Event>>>
      _pagingUpController;
  late final PagingController<DateTime, Map<DateTime, List<Event>>>
      _pagingDownController;
  late ScrollController _scrollController;

  late final EventProvider _eventProvider;

  // 중복 fetch 를 방지하기 위한 flag
  // 오늘 날짜 index 를 0으로, 내일 index 는 1, 어제 index 는 -1
  // if fetchFlag[0] == true, already fetched
  // else if fetchFlag[-2] == null, not fetched yet
  Map<int, bool> fetchFlag = {};

  final Key downListKey = UniqueKey();

  static const double hourHeight = DuaryTimetable.hourHeight;

  late DateTime nextUpPageKey;

  late DateTime nextDownPageKey;

  final DuaryContext duaryContext = DuaryContext();

  late void Function() meListener;
  late void Function() loverListener;
  late void Function() coupleListener;

  @override
  void initState() {
    super.initState();

    dayFocus = widget.initialDate;
    initialDayIndex = (dayFocus.difference(DateTime.now()).inHours / 24).ceil();
    dayIndex = initialDayIndex;

    nextUpPageKey = dayFocus.subtract(const Duration(days: 1));
    nextDownPageKey = dayFocus;

    _eventProvider = context.read<EventProvider>();

    _pagingUpController = PagingController(getNextPageKey: (state) {
      return nextUpPageKey;
    }, fetchPage: (pageKey) {
      return _fetchUpPage(pageKey);
    });
    _pagingDownController = PagingController(getNextPageKey: (state) {
      return nextDownPageKey;
    }, fetchPage: (pageKey) {
      return _fetchDownPage(pageKey);
    });

    _scrollController = ScrollController();
    _scrollController.addListener(updateDayIndex);

    // 유저 정보나 커플 정보가 바뀌면 다시 event 불러오기
    meListener = refresh;
    loverListener = refresh;
    coupleListener = refresh;
    duaryContext.me.addListener(meListener);
    duaryContext.lover.addListener(loverListener);
    duaryContext.myCouple.addListener(coupleListener);
  }

  void refresh() {
    dayFocus = DateUtils.dateOnly(DateTime.now());
    initialDayIndex = (dayFocus.difference(DateTime.now()).inHours / 24).ceil();
    dayIndex = initialDayIndex;

    nextUpPageKey = dayFocus.subtract(const Duration(days: 1));
    nextDownPageKey = dayFocus;

    _pagingDownController.refresh();
    _pagingUpController.refresh();
    fetchFlag.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _pagingDownController.dispose();
    _pagingUpController.dispose();
    duaryContext.me.removeListener(meListener);
    duaryContext.lover.removeListener(loverListener);
    duaryContext.myCouple.removeListener(coupleListener);
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
        dayFocus = DateUtils.dateOnly(DateTime.now()).add(Duration(days: dayIndex));
      });
    }
  }

  Future<List<Map<DateTime, List<Event>>>> _fetchDownPage(
      DateTime pageKey) async {
    // 하루동안의 event 불러옴
    DateTime startDate = DateTime(pageKey.year, pageKey.month, pageKey.day);
    final newItems = await _eventProvider.getEventByDay(startDate);

    fetchFlag[dayIndex] = true;

    nextDownPageKey = pageKey.add(const Duration(days: 1));

    return [
      {pageKey: newItems}
    ];
  }

  Future<List<Map<DateTime, List<Event>>>> _fetchUpPage(
      DateTime pageKey) async {
    // 하루동안의 event 불러옴
    DateTime startDate = DateTime(pageKey.year, pageKey.month, pageKey.day);
    final newItems = await _eventProvider.getEventByDay(startDate);

    fetchFlag[dayIndex] = true;

    nextUpPageKey = pageKey.subtract(const Duration(days: 1));

    return [
      {pageKey: newItems}
    ];
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
            dayIndex: dayIndex,
            dayFocus: dayFocus,
            onDateTap: () => widget.onDateTap(dayFocus),
            refresh: refresh),
        // Two way(up, down) Infinite Scroll View
        Flexible(
          child: Scrollable(
            controller: _scrollController,
            viewportBuilder: (BuildContext context, ViewportOffset position) {
              return Viewport(
                offset: position,
                center: downListKey,
                slivers: [
                  PagingListener(
                    controller: _pagingUpController,
                    builder: (context, state, fetchNextPage) =>
                        PagedSliverList<DateTime, Map<DateTime, List<Event>>>(
                      nextPageStrategy: () {
                        if (dayIndex < initialDayIndex &&
                            fetchFlag[dayIndex] == null) {
                          return true;
                        } else {
                          return false;
                        }
                      },
                      builderDelegate: PagedChildBuilderDelegate(
                          itemBuilder: (context, items, index) {
                        DateTime date = items.keys.first;
                        final List<Event> events = items[date]!;
                        return DayView(currentDate: date, items: events, refresh: refresh,);
                      }, firstPageErrorIndicatorBuilder: (context) {
                        return const Center(
                          child: Text("일정을 불러오는 데에 실패했습니다"),
                        );
                      }),
                      state: state,
                      fetchNextPage: fetchNextPage,
                    ),
                  ),
                  PagingListener(
                      key: downListKey,
                      controller: _pagingDownController,
                      builder: (context, state, fetchNextPage) {
                        return PagedSliverList<DateTime,
                                Map<DateTime, List<Event>>>(
                            nextPageStrategy: () {
                              if (dayIndex >= initialDayIndex &&
                                  fetchFlag[dayIndex] == null) {
                                return true;
                              } else {
                                return false;
                              }
                            },
                            key: downListKey,
                            state: state,
                            fetchNextPage: fetchNextPage,
                            builderDelegate: PagedChildBuilderDelegate(
                                itemBuilder: (context, items, index) {
                              DateTime date = items.keys.first;
                              final List<Event> events = items[date]!;
                              return DayView(
                                  currentDate: date, items: events, refresh:  refresh,);
                            }, firstPageErrorIndicatorBuilder: (context) {
                              return const Center(
                                child: Text("일정을 불러오는 데에 실패했습니다"),
                              );
                            }));
                      }),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
