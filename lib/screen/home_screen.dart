import 'dart:math';

import 'package:duary/model/enums/character.dart';
import 'package:duary/model/event.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/screen/event_details_screen.dart';
import 'package:duary/screen/my_page_screen.dart';
import 'package:duary/screen/schedule_screen.dart';
import 'package:duary/support/button_base.dart';
import 'package:duary/widget/characters.dart';
import 'package:duary/widget/main_app_bar.dart';
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

  static const String _noOngoingEventMent = "쉬는 중이야";

  late Future<Map<Member, Event?>> getOngoingEventRequest;

  static const double _minSheetSize = 0.12;

  late Member me;

  late Member lover;

  @override
  void initState() {
    super.initState();
    _eventProvider = context.read<EventProvider>();

    me = _eventProvider.me!;
    lover = _eventProvider.lover!;

    getOngoingEventRequest = _eventProvider.getOngoingEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBarObj: AppBar(),
        leadingBuilder: (context) => ButtonBase(
            onTap: () {
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
                            child: Character.characterWidget(me.character!,
                                width: 41, height: 63, opacity: 1)),
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
                            FutureBuilder(
                                future: getOngoingEventRequest,
                                builder: (context, snapshot) {
                                  String title = _noOngoingEventMent;
                                  if (snapshot.hasData) {
                                    title = snapshot.data![me]?.title ??
                                        _noOngoingEventMent;
                                  }
                                  return Text(
                                    title,
                                    style: const TextStyle(
                                        color: Color(0xFF111111),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  );
                                })
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
                            FutureBuilder(
                                future: getOngoingEventRequest,
                                builder: (context, snapshot) {
                                  String title = _noOngoingEventMent;
                                  if (snapshot.hasData) {
                                    title = snapshot.data![lover]?.title ??
                                        _noOngoingEventMent;
                                  }
                                  return Text(
                                    title,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        color: Color(0xFF111111),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  );
                                }),
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
                          child: const Yellow(
                            width: 41,
                            height: 41,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     ButtonBase(
                  //         onTap: () {},
                  //         child: const Row(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Text(
                  //               "오늘 일정 보기",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.w400,
                  //                   fontSize: 11,
                  //                   color: Color(0xFF939393)),
                  //             ),
                  //             Icon(
                  //               Icons.chevron_right,
                  //               color: Color(0xFF939393),
                  //               size: 14,
                  //             )
                  //           ],
                  //         )),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),

                  FutureBuilder(
                      future: _eventProvider.getComingEvent(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Event> comingEvents = snapshot.data!;
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10,
                            ),
                            shrinkWrap: true,
                            itemCount: comingEvents.length,
                            itemBuilder: (context, index) {
                              return ComingEventCard(
                                  event: comingEvents[index]);
                            },
                          );
                        } else {
                          return Container();
                        }
                      }),
                ],
              ),
            ),
            DraggableScrollableSheet(
                minChildSize: _minSheetSize,
                initialChildSize: _minSheetSize,
                snap: true,
                builder: (ctx, controller) {
                  return Container(
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
          child: Blue(
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
