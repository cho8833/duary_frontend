import 'dart:async';
import 'dart:math';

import 'package:duary/model/enums/character.dart';
import 'package:duary/model/event.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/provider/time_manager.dart';
import 'package:duary/screen/event/event_details_screen.dart';
import 'package:duary/screen/my_page/my_page_screen.dart';
import 'package:duary/screen/timetable_screen.dart';

import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/button_base.dart';
import 'package:duary/widget/character_widget.dart';
import 'package:duary/widget/set_character.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final EventProvider _eventProvider;
  late final TimeManager _timeManager;
  final DuaryContext duaryContext = DuaryContext();

  static const String _noOngoingEventMent = "쉬는 중이야";

  Event? myOnGoingEvent;
  Event? loverOnGoingEvent;
  List<Event> comingEvents = [];

  DateTime now = DateTime.now();
  late DateTime today;

  static const double _minSheetSize = 0.12;

  late Member me;

  late Member lover;

  late final void Function() meListener;
  late final void Function() loverListener;

  DraggableScrollableController sheetController =
      DraggableScrollableController();

  late final void Function() eventDataListener;

  @override
  void initState() {
    super.initState();
    today = DateUtils.dateOnly(now);
    _eventProvider = context.read<EventProvider>();

    me = duaryContext.me.value!;
    lover = duaryContext.lover.value!;
    meListener = () {
      if (duaryContext.me.value != null) {
        setState(() {
          me = duaryContext.me.value!;
        });
      }
      return;
    };
    loverListener = () {
      if (duaryContext.myCouple.value != null) {
        setState(() {
          lover = duaryContext.lover.value!;
        });
      }
    };

    duaryContext.me.addListener(meListener);
    duaryContext.lover.addListener(loverListener);

    eventDataListener = () {
      List<Event>? todayEvents =
          _eventProvider.eventDataNotifier.eventMap[today];
      if (todayEvents != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          refreshOnGoing(todayEvents);
          refreshComingEvents(todayEvents);
        });
      }
    };
    _eventProvider.eventDataNotifier.addListener(eventDataListener);

    _timeManager = context.read<TimeManager>();
    _timeManager.addListener(_changeTime);
  }

  void _changeTime() {
    if (now.minute != _timeManager.now.minute) {
      now = _timeManager.now;
      today = DateUtils.dateOnly(now);
      List<Event>? todayEvents = _eventProvider.eventDataNotifier.get(today);
      if (todayEvents != null) {
        refreshOnGoing(todayEvents);
        refreshComingEvents(todayEvents);
      }
    }
  }

  void refreshOnGoing(List<Event> todayEvents) {

      try {
        setState(() {
          myOnGoingEvent = todayEvents.lastWhere((e) =>
          (e.createdBy == me.getId() || e.isTogether) &&
              e.startDateTime.isBefore(now) &&
              e.endDateTime.isAfter(now));
        });
      } catch (_) {}

      try {
        setState(() {
          loverOnGoingEvent = todayEvents.lastWhere((e) =>
          (e.createdBy == lover.getId() || e.isTogether) &&
              e.startDateTime.isBefore(now) &&
              e.endDateTime.isAfter(now));
        });
      } catch (_) {}

  }

  void refreshComingEvents(List<Event> todayEvents) {
      setState(() {
        comingEvents =
            todayEvents.where((e) => e.startDateTime.isAfter(now)).toList();
        comingEvents
            .sort((e1, e2) => e1.startDateTime.compareTo(e2.startDateTime));
      });

  }

  @override
  void dispose() {
    duaryContext.me.removeListener(meListener);
    duaryContext.lover.removeListener(loverListener);
    _timeManager.removeListener(_changeTime);
    _eventProvider.eventDataNotifier.removeListener(eventDataListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBarObj: AppBar(),
        leadingBuilder: (context) => FutureButton(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyPageScreen()));
            },
            child: const Icon(Icons.menu)),
        trailingBuilder: (context) => const Icon(Icons.notifications_outlined),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 41,
                        width: 41,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: Character.characterCircleWidget(
                                me.character!,
                                size: 40)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFF555555)
                                      .withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2))
                            ]),
                        child: Row(
                          children: [
                            Text(
                              me.name!,
                              style: TextStyle(
                                  color: me.character!.characterColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              color: me.character!.characterColor,
                              width: 1,
                              height: 19,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              myOnGoingEvent?.title ?? _noOngoingEventMent,
                              style: const TextStyle(
                                  color: Color(0xFF111111),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFF555555)
                                      .withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2))
                            ]),
                        child: Row(
                          children: [
                            Text(
                              loverOnGoingEvent?.title ?? _noOngoingEventMent,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  color: Color(0xFF111111),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              color: lover.character!.characterColor,
                              width: 1,
                              height: 19,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              lover.name!,
                              style: TextStyle(
                                  color: lover.character!.characterColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 41,
                        width: 41,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: Character.characterCircleWidget(
                              lover.character!,
                              size: 40),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    shrinkWrap: true,
                    itemCount: comingEvents.length,
                    itemBuilder: (context, index) {
                      return ComingEventCard(event: comingEvents[index]);
                    },
                  ),
                ],
              ),
            ),
            DraggableScrollableSheet(
                controller: sheetController,
                minChildSize: _minSheetSize,
                initialChildSize: _minSheetSize,
                snap: true,
                builder: (ctx, controller) {
                  return FutureButton(
                    onTap: () async {
                      sheetController.animateTo(1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.from(
                                  alpha: 0.1, red: 0, green: 0, blue: 0),
                              offset: Offset(0, -2),
                              blurRadius: 15)
                        ],
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        // 오버스크롤(바운딩) 방지
                        controller: controller,
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: const TimetableScreen(),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        );
      }),
    );
  }
}

class ComingEventCard extends StatelessWidget {
  const ComingEventCard({super.key, required this.event});

  final Event event;

  Widget drawCharacter(Event event, Color color) {
    if (event.isTogether) {
      return Positioned(
        top: 61,
        left: -5,
        child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(pi),
            child: const SetCharacter(
              width: 137,
              height: 167,
              opacity: 0.2,
            )),
      );
    }
    if (event.member.character == Character.yellow) {
      return Positioned(
        top: 51,
        left: -5,
        child: Yellow(width: 113, height: 113, color: color, opacity: 0.2),
      );
    } else if (event.member.character == Character.blue) {
      return Positioned(
        top: 44,
        left: -5,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: const Blue(
            width: 114,
            height: 196,
            opacity: 0.2,
          ),
        ),
      );
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = event.member.character!.strokeColor;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetailsScreen(event: event)));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: 136,
          decoration: BoxDecoration(
            color: (event.isTogether ? const Color(0xFFFF488A) : color)
                .withValues(alpha: 0.2),
          ),
          child: Stack(
            children: [
              drawCharacter(event, color),
              Positioned(
                top: 20,
                left: 0,
                child: Container(
                  width: 80,
                  height: 45,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: event.isTogether ? const Color(0xFFFF488A) : color,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    DateFormat("a").format(event.startDateTime),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                    color: Colors.white),
                              ),
                              TextSpan(
                                text:
                                    " ${DateFormat("h:mm").format(event.startDateTime)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Colors.white),
                              )
                            ],
                            style: const TextStyle(
                                fontFamily: "NanumSquareRound")),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 25,
                left: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "다가오는 일정",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                    ),
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xFF2E1A00),
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "장소 및 메모",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                    ),
                    Text(
                      event.content ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xFF2E1A00),
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
