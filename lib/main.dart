import 'package:duary/firebase_options.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/screen/splash_screen.dart';
import 'package:duary/support/asset_path.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:duary/provider/theme_provider.dart';
import 'package:duary/provider/token_provider.dart';
import 'package:duary/repository/impl/secure_storage_impl.dart';
import 'package:duary/support/repository_container.dart';
import 'package:duary/repository/secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init kakao sdk
  KakaoSdk.init(
    nativeAppKey: 'c39358bbd16f0444208eb658c37cd69e',
  );
  // secure storage
  FlutterSecureStorage ss = const FlutterSecureStorage();
  final SecureStorage secureStorage = SecureStorageImpl(ss);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final fcmToken = await FirebaseMessaging.instance.getToken();

  // pre cache splash logo
  // Native Splash Screen -> SplashScreen.dart 전환 중 로고 깜빡임 제거
  const loader = SvgAssetLoader(AssetPath.duarySplashLogo);
  await svg.cache
      .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));

  // token provider
  TokenProvider tokenProvider = TokenProvider();
  tokenProvider.secureStorage = secureStorage;

  // initialize repository container
  RepositoryContainer rc = RepositoryContainer();
  rc.initialize(secureStorage);

  EventProvider eventProvider = EventProvider(rc.eventRepository);
  DuaryContext duaryContext = DuaryContext();
  duaryContext.init(rc.coupleRepository, rc.authRepository);

  // 로그인
  // await duaryContext.checkSignIn().then((_) async {
  //   // 로그인 성공한 경우, 커플 정보까지 가져옴
  //   if (duaryContext.me.value != null) {
  //     if (duaryContext.me.value!.coupleId != null) {
  //       await duaryContext.getMyCouple().catchError((e) {
  //         Fluttertoast.showToast(msg: e.toString());
  //       });
  //     }
  //   }
  // });

  runApp(Main(eventProvider: eventProvider));
}

class Main extends StatelessWidget {
  const Main(
      {super.key, required this.eventProvider});
  final EventProvider eventProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider.value(value: eventProvider)
      ],
      builder: (context, _) =>
          Consumer<ThemeProvider>(builder: (context, provider, _) {
        return GetMaterialApp(
            theme: provider.selected,
            debugShowCheckedModeBanner: false,
            // darkTheme: ThemeProvider.dark,
            home: const SplashScreen());
      }),
    );
  }
}
