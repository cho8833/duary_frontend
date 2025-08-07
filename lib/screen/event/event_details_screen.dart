import 'package:duary/model/enums/character.dart';
import 'package:duary/model/event.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/screen/event/edit_event_screen.dart';
import 'package:duary/support/custom_page_route.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/button_base.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key, required this.event});

  final Event event;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {

  late final EventProvider _eventProvider;

  late Event event = widget.event;

  @override
  void initState() {
    _eventProvider = context.read<EventProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBase(
          appBarObj: AppBar(),
          leadingBuilder: (context) => GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
                  children: [
                    const Icon(
                      Icons.chevron_left,
                      size: 24,
                    ),
                    Text(
                      DateFormat("M월 dd일").format(event.startDateTime),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    )
                  ],
                ),
          ),
          centerBuilder: (context) => const Text(
                "상세 일정",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFE8F00)),
              )),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 일정 제목
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: event.isTogether
                        ? Character.together.characterColor
                        : event.member.character!.characterColor,
                  ),
                  child: Text(
                    event.isTogether ? "같이" : event.member.name!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  event.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                )
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // 일정 날짜
            _subTitle(_formatDate(event.startDateTime)),
            _subTitle(
                "${DateFormat("h:mm").format(event.startDateTime)} - ${DateFormat("h:mm").format(event.endDateTime)}"),

            // divider
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 1,
              color: const Color(0xFFF3F3F3),
              width: double.infinity,
            ),
            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _subTitle("장소"),
                    const SizedBox(
                      height: 10,
                    ),
                    _content(event.location ?? ""),
                    const SizedBox(
                      height: 30,
                    ),
                    _subTitle("만나는 사람"),
                    const SizedBox(
                      height: 10,
                    ),
                    _content(event.hangOutWith ?? ""),
                    const SizedBox(
                      height: 30,
                    ),
                    _subTitle("메모"),
                    const SizedBox(
                      height: 10,
                    ),
                    _content(event.content ?? ""),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(SlideDownRoute(page: EditEventScreen(event: event,))).then((updated) {
                      try {
                        if ((updated as Event?) != null) {
                          setState(() {
                            event = updated!;
                          });
                        }
                      } catch (_) {}
                });
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xFFFFBD64)),
                child: const Center(
                  child: Text(
                    "일정 수정하기",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF573200)),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                FutureButton(
                  onTap: () async {
                    _eventProvider.deleteEvent(event).then((_) {
                      Navigator.pop(context, true);
                    }).catchError((e) {
                      Fluttertoast.showToast(msg: e.toString());
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFFFBD64), width: 2),
                    ),
                    child: const Center(
                      child: Text("일정 삭제하기",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF573200))),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _subTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3C3C3C)),
    );
  }

  Widget _content(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xFF393939)),
    );
  }

  String _formatDate(DateTime date) {
    return "${DateFormat("yyyy년 M월 dd일").format(date)} ${DateFormat.E("ko_KR").format(date)}요일";
  }
}
