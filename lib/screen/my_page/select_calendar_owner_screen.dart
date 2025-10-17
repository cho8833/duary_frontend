import 'package:device_calendar/device_calendar.dart' show Calendar;
import 'package:duary/model/member.dart';
import 'package:duary/model/third_party_calendar.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/screen/my_page/my_page_screen.dart';
import 'package:duary/support/asset_path.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/duary_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' show Fluttertoast;
import 'package:provider/provider.dart';

class SelectCalendarOwnerScreen extends StatefulWidget {
  const SelectCalendarOwnerScreen(
      {super.key, required this.calendar, required this.initialValue});

  final Calendar calendar;

  final AppleCalendar? initialValue;

  @override
  State<SelectCalendarOwnerScreen> createState() =>
      _SelectCalendarOwnerScreenState();
}

class _SelectCalendarOwnerScreenState extends State<SelectCalendarOwnerScreen> {
  static const List<CalendarOwner> owners = CalendarOwner.values;

  late final EventProvider _eventProvider = context.read<EventProvider>();

  CalendarOwner? value;

  static const Map<CalendarOwner, String> bubblePreviewPath = {
    CalendarOwner.lover: AssetPath.loverMeBubblePreview,
    CalendarOwner.my: AssetPath.loverMeBubblePreview,
    CalendarOwner.together: AssetPath.togetherBubblePreview,
  };

  static final Map<CalendarOwner, Image> comingPreviewPath = {
    CalendarOwner.lover: Image.asset(AssetPath.loverMeComingPreview),
    CalendarOwner.my: Image.asset(AssetPath.loverMeComingPreview),
    CalendarOwner.together: Image.asset(AssetPath.togetherComingPreview)
  };

  @override
  void initState() {
    super.initState();
    value = widget.initialValue?.owner;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final img in comingPreviewPath.values) {
      precacheImage(img.image, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubPageAppBar(
          appBarObj: AppBar(), title: const SubPageTitle(title: "캘린더 구분")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                children: [
                  RadioListTile(
                      title: const Text("설정하지 않음"),
                      value: null,
                      groupValue: value,
                      onChanged: (selected) {
                        setState(() {
                          value = null;
                        });
                      }),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: owners.length,
                      itemBuilder: (context, index) {
                        return RadioListTile(
                            title: Text("${owners[index].title}으로 설정하기"),
                            value: owners[index],
                            groupValue: value,
                            onChanged: (selected) {
                              setState(() {
                                value = selected!;
                              });
                            });
                      }),
                  const SizedBox(
                    height: 16,
                  ),
                  value != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionTitle(text: "이렇게 보여요"),
                            const SizedBox(
                              height: 8,
                            ),
                            comingPreviewPath[value]!,
                          ],
                        )
                      : Container(),
                  const Spacer(),
                  DuaryConfirmButton(
                      title: "설정하기",
                      onTap: () async {
                        Future<void> process() async {
                          // 설정하지 않음 -> sync 해제
                          if (value != null) {
                            _eventProvider.updateSyncedAppleCalendar(AppleCalendar.fromApple(widget.calendar, value!));
                          }
                          // update or add
                          else {
                            _eventProvider.removeSyncedAppleCalendar(widget.calendar.id!);
                          }
                        }

                        await process().then((_) {
                          Navigator.pop(context);
                        }).catchError((e) {
                          Fluttertoast.showToast(msg: e.toString());
                        });

                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
