import 'dart:async';

import 'package:duary/model/event.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:flutter/foundation.dart';
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
  late final PagingController<DateTime, Event> _pagingUpController;
  late final PagingController<DateTime, Event> _pagingDownController;
  late final ScrollController _scrollController;
  late final EventProvider _eventProvider;

  // 중복 fetch 를 방지하기 위한 flag
  // 오늘 날짜 index 를 0으로, 내일 index 는 1, 어제 index 는 0
  // if fetchFlag[0] == true, already fetched
  // else if fetchFlag[-2] == null, noy fetched yet
  final Map<int, bool> fetchFlag = {};

  final Key downListKey = UniqueKey();

  static const double _hourHeight = 62;

  @override
  void initState() {
    super.initState();
    _eventProvider = context.read<EventProvider>();

    _pagingUpController =
        PagingController(firstPageKey: DateTime.now().subtract(const Duration(days: 1)));
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
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      offset = _scrollController.offset;
    }
    // 아래로 스크롤 중이면 화면 하단을 기준으로 어느 날짜 블록에 있는지 계산
    else {
      offset = _scrollController.offset + _scrollController.position.viewportDimension;
    }

    return (offset / dayBlockHeight).floor();
  }

  Future<void> _fetchDownPage(DateTime pageKey) async {
    try {
      final newItems = await _eventProvider.getEvent(pageKey);

      final DateTime nextPageKey = pageKey.add(const Duration(days: 1));

      _pagingDownController.appendPage(newItems, nextPageKey);
    } catch (error) {
      _pagingDownController.error = error;
    }
  }

  Future<void> _fetchUpPage(DateTime pageKey) async {
    try {
      final newItems = await _eventProvider.getEvent(pageKey);

      final DateTime nextPageKey = pageKey.subtract(const Duration(days: 1));

      _pagingUpController.appendPage(newItems, nextPageKey);
    } catch (error) {
      _pagingUpController.error = error;
    }
  }

  Widget _buildTimeLines() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(24, (index) {
          return Container(
            color: const Color(0xFFFBFBFB),
            width: 22,
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
      ),
    );
  }

  Widget _buildDateTitle() {
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

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("ko_KR");
    return Column(
      children: [
        SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDateTitle(),
              ],
            )),
        // Two way(up, down) Infinite Scroll View
        Expanded(
          child: Scrollable(
            controller: _scrollController,
            viewportBuilder: (BuildContext context, ViewportOffset position) {
              return Viewport(
                offset: position,
                center: downListKey,
                slivers: [
                  PagedSliverList(
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
                          itemBuilder: (context, item, index) => Stack(
                                children: [
                                  _buildTimeLines(),
                                  CustomPaint(
                                    size: const Size(167, 62),
                                    painter: _SpeechBubblePainter(isLeft: true),
                                  ),
                                ],
                              ))),
                  PagedSliverList(
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
                          itemBuilder: (context, item, index) => Stack(
                                children: [
                                  _buildTimeLines(),
                                  CustomPaint(
                                    size: const Size(167, 62),
                                    painter: _SpeechBubblePainter(isLeft: true),
                                  ),
                                ],
                              ))),
                ],
              );
            },
          ),
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

class _SpeechBubblePainter extends CustomPainter {
  final bool isLeft;

  _SpeechBubblePainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFFFA93A).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw the rounded rectangle
    if (isLeft) {
      // If flipped, draw the rectangle on the right
      final RRect roundedRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.1, 0, size.width * 0.9, size.height),
        const Radius.circular(20),
      );
      canvas.drawRRect(roundedRect, paint);

      // Draw the triangle on the left
      final Path trianglePath = Path();
      trianglePath.moveTo(size.width * 0.1, size.height * 0.5);
      trianglePath.lineTo(size.width * 0.1, size.height * 0.7);
      trianglePath.lineTo(0, size.height * 0.6);
      trianglePath.close();

      canvas.drawPath(trianglePath, paint);
    } else {
      // If not flipped, draw the rectangle on the left
      final RRect roundedRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * 0.9, size.height),
        const Radius.circular(20),
      );
      canvas.drawRRect(roundedRect, paint);

      // Draw the triangle on the right
      final Path trianglePath = Path();
      trianglePath.moveTo(size.width * 0.9, size.height * 0.5);
      trianglePath.lineTo(size.width * 0.9, size.height * 0.7);
      trianglePath.lineTo(size.width, size.height * 0.6);
      trianglePath.close();

      canvas.drawPath(trianglePath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpeechBubblePainter oldDelegate) {
    return false;
  }
}
