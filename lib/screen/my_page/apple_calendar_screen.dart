import 'package:device_calendar/device_calendar.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/screen/my_page/my_info_screen.dart';
import 'package:duary/screen/my_page/my_page_screen.dart' show SectionTitle;
import 'package:duary/screen/my_page/select_calendar_owner_screen.dart';
import 'package:duary/support/custom_exception.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/button_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppleCalendarScreen extends StatefulWidget {
  const AppleCalendarScreen({super.key});

  @override
  State<AppleCalendarScreen> createState() => _AppleCalendarScreenState();
}

class _AppleCalendarScreenState extends State<AppleCalendarScreen> {
  late EventProvider eventProvider = context.read<EventProvider>();

  final duaryContext = DuaryContext();

  bool _isPermissionGranted = false;

  late List<AppleCalendar> syncedCalendar =
      duaryContext.me.value?.syncedAppleCalendar ?? [];

  @override
  void initState() {
    super.initState();
    eventProvider.getApplePermission().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((d) {
        setState(() {
          _isPermissionGranted = value;
        });
      });
    });
    duaryContext.me.addListener(myInfoListener);
  }

  void myInfoListener() {
    setState(() {
      syncedCalendar = duaryContext.me.value?.syncedAppleCalendar ?? [];
    });
  }

  @override
  void dispose() {
    duaryContext.me.removeListener(myInfoListener);
    super.dispose();
  }

  Future<void> launchSettings() async {
    Uri settings = Uri.parse("app-settings:root=Duary");
    if (await canLaunchUrl(settings)) {
    launchUrl(settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubPageAppBar(
          appBarObj: AppBar(), title: const SubPageTitle(title: "캘린더 연동")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              child: Column(
                children: [
                  FutureButton(
                    onTap: () async {
                      if (!_isPermissionGranted) {
                        await eventProvider
                            .requestApplePermission()
                            .then((value) {
                              if (!value) {
                                launchSettings();
                              } else {
                                setState(() {
                                  _isPermissionGranted = value;
                                });
                              }
                        });
                      } else {
                        launchSettings();
                      }
                    },
                    child: InfoBox(
                        labelText: "권한",
                        value: Row(
                          children: [
                            Text(_isPermissionGranted ? "허용됨" : "허용되지 않음"),
                            const Icon(Icons.chevron_right)
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FutureBuilder(
                      future: eventProvider.getAppleCalendars(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return _CalendarList(
                              calendars: snapshot.data!,
                              selectedCalendars:
                                  syncedCalendar);
                        } else if (snapshot.hasError) {
                          if (snapshot.error is PermissionDeniedException) {
                            return Container();
                          }
                          return const Center(child: Text("캘린더를 불러오지 못했습니다.\n권한을 허용해도 문제가 계속된다면,\n앱을 재실행해주세요."));
                        } else {
                          return Container();
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarList extends StatelessWidget {
  const _CalendarList(
      {super.key, required this.calendars, required this.selectedCalendars});

  final List<Calendar> calendars;

  final List<AppleCalendar> selectedCalendars;

  Map<String, List<Calendar>> sortCalendars() {
    Map<String, List<Calendar>> result = {};

    for (final calendar in calendars) {
      List<Calendar> sorted = result[calendar.accountName] ?? [];
      sorted.add(calendar);
      result[calendar.accountName!] = sorted;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Calendar>> sorted = sortCalendars();
    List<String> accounts = sorted.keys.toList();
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, accountIndex) {
          String accountName = accounts[accountIndex];
          List<Calendar> calendars = sorted[accountName]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(text: accountName),
              const SizedBox(
                height: 8,
              ),
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, calendarIndex) {
                    Calendar calendar = calendars[calendarIndex];
                    AppleCalendar? userSetting;
                    try {
                      userSetting = selectedCalendars.firstWhere((c) => c.id == calendar.id);
                    } catch (_) {}
                    return _Calendar(
                        calendar: calendar,
                        value: userSetting);
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 8,
                      ),
                  itemCount: calendars.length),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
              height: 16,
            ),
        itemCount: accounts.length);
  }
}

class _Calendar extends StatelessWidget {
  const _Calendar(
      {super.key, required this.calendar, this.value});

  final Calendar calendar;

  final AppleCalendar? value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectCalendarOwnerScreen(
                      calendar: calendar, initialValue: value,
                    )));

      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Color(calendar.color!),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    calendar.name!,
                    style: const TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              value != null ? _ValueText(currentValue: value!.owner.title) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueText extends StatelessWidget {
  const _ValueText({super.key, required this.currentValue});

  final String currentValue;

  @override
  Widget build(BuildContext context) {
    return Text(
      currentValue,
      style: const TextStyle(
        color: Color(0xFFB6B6B6),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}