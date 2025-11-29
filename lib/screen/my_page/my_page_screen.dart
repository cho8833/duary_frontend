import 'package:duary/model/couple.dart';
import 'package:duary/model/enums/character.dart';
import 'package:duary/model/member.dart';
import 'package:duary/model/third_party_calendar.dart';
import 'package:duary/provider/auth_provider.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/provider/notification_provider.dart';
import 'package:duary/screen/my_page/change_character_screen.dart';
import 'package:duary/screen/my_page/couple_info_screen.dart';
import 'package:duary/screen/my_page/edit_birthday_screen.dart';
import 'package:duary/screen/my_page/edit_name_screen.dart';
import 'package:duary/screen/login_screen.dart';
import 'package:duary/screen/my_page/edit_relation_date_screen.dart';
import 'package:duary/screen/my_page/my_info_screen.dart';
import 'package:duary/widget/button_base.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> with WidgetsBindingObserver {

  DuaryContext duaryContext = DuaryContext();
  late final EventProvider _eventProvider = context.read<EventProvider>();
  late final NotificationProvider _notificationProvider =
      context.read<NotificationProvider>();

  late Member me;

  late Couple myCouple;

  late final void Function() meListener;
  late final void Function() coupleListener;
  late final void Function() appleCalendarListener;
  late final void Function() notiPermissionListener;

  List<AppleCalendar> syncedAppleCalendar = [];

  bool isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Init my info and Listen my info changes
    me = duaryContext.me.value!;
    meListener = () {
      if (duaryContext.me.value != null) {
        setState(() {
          me = duaryContext.me.value!;
        });
      }
      return;
    };
    duaryContext.me.addListener(meListener);

    // Init couple info and Listen couple info changes
    myCouple = duaryContext.myCouple.value!;
    coupleListener = () {
      if (duaryContext.myCouple.value != null) {
        setState(() {
          myCouple = duaryContext.myCouple.value!;
        });
      }
    };
    duaryContext.myCouple.addListener(coupleListener);

    // Init synced apple calendar and Listen synced apple calendar changes
    syncedAppleCalendar = _eventProvider.appleCalendars.value;
    appleCalendarListener = () {
      setState(() {
        syncedAppleCalendar = _eventProvider.appleCalendars.value;
      });
    };
    _eventProvider.appleCalendars.addListener(appleCalendarListener);

    // Init notification settings and listen notification permission
    isNotificationEnabled = _notificationProvider.isNotificationEnabled.value;
    notiPermissionListener = () {
      setState(() {
        isNotificationEnabled =
            _notificationProvider.isNotificationEnabled.value;
      });
    };
    _notificationProvider.isNotificationEnabled
        .addListener(notiPermissionListener);

    // 앱 실행 중 알림 권한이 바뀌었을 가능성이 있으므로, init state 시 권한을 다시 조회
    // init state 시 바로 권한을 받아올 경우 initState 중 setState가 발생할 가능성이 있음
    // -> 빌드 완료 된 후 권한 조회
    WidgetsBinding.instance.addPostFrameCallback((d) {
      _notificationProvider.getPermission();
    });
  }

  // 앱이 다시 foreground 로 전환될 경우, 알림 권한을 다시 설정했을 가능성이 있으므로 다시 조회
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _notificationProvider.getPermission();
    }
  }

  String formatDateTime(DateTime req) => DateFormat('yy.MM.dd').format(req);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBase(
          appBarObj: AppBar(),
          leadingBuilder: (context) => FutureButton(
              onTap: () async {
                Navigator.pop(context);
              },
              child: const Icon(Icons.navigate_before)),
          centerBuilder: (context) => const SubPageTitle(title: "마이페이지")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ChangeCharacterScreen()));
                      },
                      child: ClipOval(
                        child: Stack(
                          children: [
                            Character.characterCircleWidget(me.character!,
                                size: 85),
                            Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 85,
                                  height: 22,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFB4B4B4)
                                          .withAlpha(200)),
                                  child: const Center(
                                      child: Text(
                                    "바꾸기",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  )),
                                ))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Container(
                        width: 248,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x555555).withOpacity(0.06),
                              offset: const Offset(0, 2),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${me.name}, 좋은 하루애오!",
                                style: const TextStyle(
                                  color: Color(0xFF434343),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyInfoScreen()));
                },
                child: const Row(
                  children: [
                    SectionTitle(text: "내 정보"),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditNameScreen()));
                  },
                  child: InfoBox(labelText: "닉네임", currentValue: me.name!)),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditBirthdayScreen()));
                  },
                  child: InfoBox(
                      labelText: "생일",
                      currentValue: me.birthday != null
                          ? formatDateTime(me.birthday!)
                          : "설정해주세요")),
              const SizedBox(
                height: 27,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CoupleInfoScreen()));
                },
                child: const Row(
                  children: [
                    SectionTitle(text: "커플 정보"),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FutureButton(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const EditRelationDateScreen()));
                  },
                  child: InfoBox(
                      labelText: "사랑이 시작된 날",
                      currentValue: myCouple.relationDate != null
                          ? formatDateTime(myCouple.relationDate!)
                          : "설정해주세요")),
              const SizedBox(
                height: 27,
              ),
              const SectionTitle(text: "알림 설정"),
              const SizedBox(
                height: 8,
              ),
              FutureButton(
                onTap: () async {
                  if (isNotificationEnabled) {
                    await launchSettings();
                  } else {
                    bool isGranted = await _notificationProvider.requestPermission();
                    if (!isGranted) {
                      await launchSettings();
                    }
                  }
                },
                child: InfoBox(
                    labelText: "알림 권한",
                    currentValue: isNotificationEnabled ? "허용됨" : "허용되지 않음"),
              ),
              // const SectionTitle(text: "캘린더 연동"),
              // const SizedBox(
              //   height: 8,
              // ),
              // GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const AppleCalendarScreen()));
              //     },
              //     child: InfoBox(
              //         labelText: "애플 캘린더",
              //         currentValue:
              //         syncedAppleCalendar.isEmpty ? "연동되지 않음" : "연동됨")),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: FutureButton(
                  onTap: () async {
                    await DuaryContext().signOut().then((_) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (p) => false);
                    });
                  },
                  child: const Text(
                    "로그아웃",
                    style: TextStyle(
                      color: Color(0xFFFF0000),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchSettings() async {
    Uri settings = Uri.parse("app-settings:root=Duary");
    if (await canLaunchUrl(settings)) {
      launchUrl(settings);
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    duaryContext.me.removeListener(meListener);
    duaryContext.myCouple.removeListener(coupleListener);
    _eventProvider.appleCalendars.removeListener(appleCalendarListener);
    _notificationProvider.isNotificationEnabled
        .removeListener(notiPermissionListener);
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF323232),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox(
      {super.key, required this.labelText, required this.currentValue});

  final String labelText;
  final String currentValue;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Text(
              labelText,
              style: const TextStyle(
                color: Color(0xFF000000),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  currentValue,
                  style: const TextStyle(
                    color: Color(0xFFB6B6B6),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFB6B6B6),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
