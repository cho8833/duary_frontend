import 'package:duary/model/enums/character.dart';
import 'package:duary/model/event.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/screen/event/edit_event_screen.dart';
import 'package:duary/screen/event/event_details_screen.dart';
import 'package:duary/support/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({
    super.key,
    required this.dayIndex,
    required this.dayFocus,
    required this.onDateTap,
    required this.refresh,
  });

  final int dayIndex;

  final DateTime dayFocus;

  final Function() onDateTap;

  final Function() refresh;

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  final DuaryContext duaryContext = DuaryContext();

  late final EventProvider _eventProvider;

  @override
  void initState() {
    _eventProvider = context.read<EventProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late String title;

    switch (widget.dayIndex) {
      case 0:
        title = "오늘";
      case 1:
        title = "내일";
      case -1:
        title = "어제";
      default:
        title = _formatDate(widget.dayFocus);
    }

    late Widget titleWidget;

    if (-2 < widget.dayIndex && widget.dayIndex < 2) {
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
            _formatDate(widget.dayFocus),
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
                widget.onDateTap();
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.chevron_left,
                    size: 24,
                  ),
                  Text(
                    "${widget.dayFocus.month}월",
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
                // 일정을 생성하고 pop 하면 hasCreated == true, 일정을 생성하지 않고 pop 하면 hasCreated == false
                Navigator.of(context)
                    .push(SlideDownRoute(page: const EditEventScreen()))
                    .then((hasCreated) {
                  if (hasCreated != null && hasCreated as bool) {
                    // 일정을 생성하면 일정을 다시 불러오기
                    widget.refresh();
                  }
                });
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
              ListenableBuilder(
                  listenable: _eventProvider.eventDataNotifier,
                  builder: (context, _) {
                    final List<Event> events =
                        _eventProvider.eventDataNotifier.get(widget.dayFocus) ?? [];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(child: myAllDay(events)),
                        const SizedBox(
                          width: 22,
                        ),
                        Expanded(child: loverAllDay(events)),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    );
                  }),
            ],
          )),
        ],
      ),
    );
  }

  Widget myAllDay(List<Event> events) {
    List<Event> my = events.where((e) {
      return e.isAllDay &&
          (e.member.socialId == duaryContext.me.value!.socialId ||
              e.isTogether);
    }).toList();

    if (my.isEmpty) {
      return const SizedBox(
        height: 8,
      );
    } else {
      List<Widget> widgets = my.map((e) {
        return Column(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => EventDetailsScreen(event: e)))
                      .then((needRefresh) {
                    if (needRefresh != null && needRefresh as bool) {
                      widget.refresh();
                    }
                  });
                },
                child: _AllDayBox(
                    title: e.title,
                    character: e.isTogether
                        ? Character.together
                        : e.member.character!)),
            const SizedBox(
              height: 4,
            )
          ],
        );
      }).toList();

      return Column(children: widgets);
    }
  }

  Widget loverAllDay(List<Event> events) {
    List<Event> lovers = events.where((e) {
      return e.isAllDay &&
          (e.member.socialId == duaryContext.lover.value!.socialId ||
              e.isTogether);
    }).toList();

    if (lovers.isEmpty) {
      return const SizedBox(
        height: 8,
      );
    } else {
      List<Widget> widgets = lovers.map((e) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventDetailsScreen(event: e)))
                    .then((needRefresh) {
                  if (needRefresh != null && needRefresh as bool) {
                    widget.refresh();
                  }
                });
              },
              child: _AllDayBox(
                  title: e.title,
                  character:
                      e.isTogether ? Character.together : e.member.character!),
            ),
            const SizedBox(
              height: 4,
            )
          ],
        );
      }).toList();

      return Column(children: widgets);
    }
  }

  String _formatDate(DateTime date) {
    return "${DateFormat("yyyy년 M월 dd일").format(widget.dayFocus)} ${DateFormat.E("ko_KR").format(widget.dayFocus)}요일";
  }
}

class _AllDayBox extends StatelessWidget {
  const _AllDayBox({super.key, required this.title, required this.character});

  final String title;

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: character.allDayColor)),
      padding: const EdgeInsets.all(8),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: character.fontBlackColor,
            fontWeight: FontWeight.w500,
            fontSize: 12),
      ),
    );
  }
}
