import 'dart:async';
import 'dart:math';

import 'package:duary/model/enums/character.dart';
import 'package:duary/model/event.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/time_manager.dart';
import 'package:duary/screen/event/event_details_screen.dart';
import 'package:duary/widget/time_table/duary_timetable.dart';
import 'package:duary/widget/time_table/bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DayView extends StatefulWidget {
  const DayView(
      {super.key,
      required this.items,
      required this.currentDate,
      required this.width});

  final List<Event> items;

  final DateTime currentDate;

  final double width;

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  final DuaryContext _duaryContext = DuaryContext();
  late final TimeManager _timeManager;

  static const hourHeight = DuaryTimetable.hourHeight;
  static const _timelineLength = DuaryTimetable.timelineLength;

  late List<Event> items;

  DateTime? now;

  @override
  void initState() {
    _timeManager = context.read<TimeManager>();
    DateTime temp = DateTime.now();
    if (DateUtils.isSameDay(temp, widget.currentDate)) {
      now = DateTime.now();
      _timeManager.addListener(_changeTime);
    }
    super.initState();
  }

  @override
  void dispose() {
    _timeManager.removeListener(_changeTime);
    super.dispose();
  }

  void _changeTime() {
    DateTime refer = _timeManager.now;
    if (now!.minute != refer.minute) {
      setState(() {
        now = refer;
      });
    }
  }

  Widget currentTimeBar() {
    if (now != null) {
      return Positioned(
          top: hourHeight * now!.hour + (hourHeight / 60) * now!.minute,
          child: Container(
            width: widget.width,
            color: Colors.orange,
            height: 1,
          ));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    items = widget.items;
    return SizedBox(
      height: hourHeight * 24,
      child: Stack(
        children: [
          currentTimeBar(),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(child: LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: _buildBubbles(constraints.maxWidth, items, true),
                );
              })),
              _buildTimeLines(),
              Expanded(child: LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: _buildBubbles(constraints.maxWidth, items, false),
                );
              })),
              const SizedBox(
                width: 20,
              ),
            ],
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

    DateTime currentDate = widget.currentDate;

    List<List<Event>> overlapGrouped =
        groupOverlappingEvents(events, currentDate, isMine: isLeft);

    for (final List<Event> overlapEvents in overlapGrouped) {
      int overlapCount = overlapEvents.length;

      for (int i = 0; i < overlapCount; i++) {
        Event event = overlapEvents[i];
        // 이벤트 위치 계산

        DateTime startTime = widget.currentDate.isAfter(event.startDateTime)
            ? widget.currentDate
            : event.startDateTime;
        DateTime tomorrow = widget.currentDate.add(const Duration(days: 1));
        DateTime endTime =
            tomorrow.isBefore(event.endDateTime) ? tomorrow : event.endDateTime;
        double yPosition =
            startTime.hour * hourHeight + (startTime.minute * 3 / 2);
        double xPosition = isLeft ? i * 20 : (overlapCount - i - 1) * 20;
        xPosition = min(maxWidth - 20, xPosition);
        // 이벤트 높이 계산, 1분 = 1px
        double height = endTime.difference(startTime).inMinutes *
            hourHeight /
            60.toDouble();

        // 이벤트 너비 계산
        double width = maxWidth - (overlapCount - 1) * 20;
        width = max(20, width);
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
                  if (zIndex != items.length - 1) {
                    setState(() {
                      items.remove(event);
                      items.add(event);
                    });
                    // Bubble 이 맨 위로 올라와 있으면 Detail Screen 으로 route
                  } else {
                    if (event.member.character != Character.none) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EventDetailsScreen(event: event)));
                    }
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

    return Bubble(
      character: character,
      width: width,
      height: height,
      isLeft: isLeft,
      content: content,
    );
  }

  List<List<Event>> groupOverlappingEvents(
      List<Event> events, DateTime currentDate,
      {required bool isMine}) {
    const int maxTime = 1440;
    final List<List<Event>> startEvents = List.generate(maxTime + 2, (_) => []);
    final List<List<Event>> endEvents = List.generate(maxTime + 2, (_) => []);

    List<Event> filtered = events.where((event) {
      if (isMine) {
        return (_duaryContext.me.value!.getId() == event.member.getId() ||
                event.isTogether) &&
            !event.isAllDay;
      } else {
        return (_duaryContext.me.value!.getId() != event.member.getId() ||
                event.isTogether) &&
            !event.isAllDay;
      }
    }).toList();

    // ID -> index 맵으로 원래 정렬 순서 추적
    final Map<String, int> eventOrder = {
      for (int i = 0; i < filtered.length; i++) filtered[i].id: i
    };

    for (final event in filtered) {
      int start = event.startDateTime.isBefore(currentDate)
          ? 0
          : event.startDateTime.hour * 60 + event.startDateTime.minute;
      int end =
          event.endDateTime.isAfter(currentDate.add(const Duration(days: 1)))
              ? maxTime
              : event.endDateTime.hour == 0
                  ? maxTime
                  : event.endDateTime.hour * 60 + event.endDateTime.minute;
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
        final group = groupIds.map((id) => eventById[id]!).toList()
          ..sort((a, b) => eventOrder[a.id]!.compareTo(eventOrder[b.id]!));

        result.add(group);
      }
    }

    return result;
  }
}
