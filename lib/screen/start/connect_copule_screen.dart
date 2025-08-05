import 'package:app_links/app_links.dart';
import 'package:duary/main.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/deep_link_manager.dart';
import 'package:duary/screen/home_screen.dart';
import 'package:duary/screen/start/input_code_screen.dart';
import 'package:duary/screen/login_screen.dart';
import 'package:duary/support/asset_path.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/button_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:provider/provider.dart';
import 'package:pulling_manager/pulling_manager.dart';
import 'package:share_plus/share_plus.dart';

class ConnectCoupleScreen extends StatefulWidget {
  const ConnectCoupleScreen({super.key});

  @override
  State<ConnectCoupleScreen> createState() => _ConnectCoupleScreenState();
}

class _ConnectCoupleScreenState extends State<ConnectCoupleScreen>
    with RouteAware {
  final DuaryContext duaryContext = DuaryContext();

  late final Member me;

  String? coupleCode;

  late DeepLinkManager linkStateManager;

  bool isPushed = false;

  void codeListener() {
    if (linkStateManager.coupleCode.value != null && !isPushed) {
      pushInputCodeScreen();
    }
  }

  void pushInputCodeScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const InputCodeScreen()));
  }

  @override
  void initState() {
    super.initState();

    linkStateManager = context.read<DeepLinkManager>();

    linkStateManager.handleUri().then((_) {
      if (linkStateManager.coupleCode.value != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          pushInputCodeScreen();
        });
      }
      linkStateManager.listenToLinkStream();
      linkStateManager.coupleCode.addListener(codeListener);
    });
    me = duaryContext.me.value!;
    duaryContext.lover.addListener(onCoupleConnected);
  }

  void onCoupleConnected() {
    if (duaryContext.lover.value != null) {
      Navigator.pop(context);
    }
  }

  @override
  void didPushNext() {
    super.didPush();
    isPushed = true;
  }

  @override
  void didPopNext() {
    super.didPopNext();
    isPushed = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBarObj: AppBar(),
        trailingBuilder: (context) => GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              color: Color(0xFF9A9A9A),
            )),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 64,
                ),
                const Text(
                  "커플 연결 후\n우리만의 다이어리를 열어보세요.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF464646),
                      fontSize: 18),
                ),
                const SizedBox(
                  height: 56,
                ),
                Image.asset(
                  AssetPath.duarySet,
                  width: 136,
                  height: 168,
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "나의 코드 복사",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF464646),
                  ),
                ),
                FutureButton(
                  onTap: () async {
                    Clipboard.setData(ClipboardData(
                            text: duaryContext.myCouple.value!.code))
                        .then((_) {
                      Fluttertoast.showToast(msg: "복사되었습니다");
                    });
                  },
                  child: Text(
                    duaryContext.myCouple.value!.code,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xFF464646),
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(48, 0, 48, 0),
                  child: Column(
                    children: [
                      FutureButton(
                          onTap: () async {
                            bool isKAkaoTalkSharingAvailable = await ShareClient
                                .instance
                                .isKakaoTalkSharingAvailable();

                            String cleandCode = duaryContext
                                .myCouple.value!.code
                                .replaceAll(RegExp(r'[\n\r\u2028\u2029]'), '')
                                .replaceAll(RegExp(r'\s{2,}'), ' ')
                                .trim();

                            TextTemplate template = TextTemplate(
                              text: "${me.name}님이 초대장을 보냈어요!",
                              link: Link(
                                androidExecutionParams: {
                                  "cleandCode": cleandCode
                                },
                                iosExecutionParams: {"cleandCode": cleandCode},
                              ),
                              buttonTitle: "커플 연결하기",
                            );

                            if (!isKAkaoTalkSharingAvailable) {
                              SharePlus.instance.share(
                                ShareParams(text: cleandCode),
                              );
                            } else {
                              try {
                                Uri uri = await ShareClient.instance
                                    .shareDefault(template: template);
                                await ShareClient.instance.launchKakaoTalk(uri);
                              } catch (e) {
                                print("카카오톡 공유 실패 : $e");
                              }
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color(0xFFffbd64)),
                            child: const Text(
                              "초대장 보내기",
                              style: TextStyle(
                                  color: Color(0xFF573200),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      const SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(child: Divider()),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'or',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF9A9A9A),
                                  fontSize: 16),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      FutureButton(
                          onTap: () async {
                            if (!isPushed) {
                              pushInputCodeScreen();
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: const Color(0xFFFFbd64), width: 2)),
                            child: const Text(
                              "상대방 코드로 연결하기",
                              style: TextStyle(
                                  color: Color(0xFF573200),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          )),
                      const SizedBox(
                        height: 19,
                      ),
                      const SizedBox(
                        height: 32,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    duaryContext.lover.removeListener(onCoupleConnected);
    routeObserver.unsubscribe(this);
    linkStateManager.cancelSubscription();
    linkStateManager.coupleCode.removeListener(codeListener);
    super.dispose();
  }
}
