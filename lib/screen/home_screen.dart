import 'dart:math';

import 'package:duary/model/enums/character.dart';
import 'package:duary/model/event.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/screen/schedule_screen.dart';
import 'package:duary/support/asset_path.dart';
import 'package:duary/support/button_base.dart';
import 'package:duary/widget/characters.dart';
import 'package:duary/widget/main_app_bar.dart';
import 'package:duary/widget/set_character.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:status_builder/status_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late EventProvider eventProvider;
  static const double _minSheetSize = 0.12;

  @override
  void initState() {
    super.initState();
    eventProvider = context.read<EventProvider>();
    eventProvider.getComingEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBarObj: AppBar(),
        leadingBuilder: (context) => const Icon(Icons.menu),
        trailingBuilder: (context) => const Icon(Icons.notifications_outlined),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MenuButton(
                          icon: Image.asset(AssetPath.coupleStamp),
                          title: "커플 스탬프",
                          onTap: () {},
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        MenuButton(
                          icon: Image.asset(AssetPath.todayDuary),
                          title: "오늘 Duary",
                          onTap: () {},
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        MenuButton(
                          icon: Image.asset(AssetPath.newSchedule),
                          title: "새 일정",
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonBase(
                            onTap: () {},
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "오늘 일정 보기",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      color: Color(0xFF939393)),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFF939393),
                                  size: 14,
                                )
                              ],
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StatusBuilder(
                        statusNotifier: eventProvider.comingEventStatus,
                        successBuilder: (context) {
                          return ListView.separated(
                            separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                            shrinkWrap: true,
                            itemCount: eventProvider.comingEvents.length,
                            itemBuilder: (context, index) {
                              return ComingEventCard(
                                  event: eventProvider.comingEvents[index]);
                            },
                          );
                        })
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
                              color: Color.from(alpha: 0.1, red: 0, green: 0, blue: 0),
                              offset: Offset(0, -2),
                              blurRadius: 15)
                        ],
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(), // 오버스크롤(바운딩) 방지
                        controller: controller,
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: const TimetableScreen(
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          );
        }
      ),
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
    Color color = event.member.character.strokeColor;
    return ClipRRect(
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
                              text: DateFormat("a").format(event.startDateTime),
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
                          style:
                              const TextStyle(fontFamily: "NanumSquareRound")),
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
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
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
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                  ),
                  Text(
                    event.content,
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
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  final Widget icon;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          height: 84,
          width: 84,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    spreadRadius: 3,
                    offset: const Offset(2, 2))
              ]),
          child: icon,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
