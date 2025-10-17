import 'package:app_links/app_links.dart' show AppLinks;
import 'package:duary/firebase_options.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/provider/deep_link_manager.dart';
import 'package:duary/provider/time_manager.dart';
import 'package:duary/repository/impl/websocket_handler.dart';
import 'package:duary/screen/splash_screen.dart';
import 'package:duary/support/asset_path.dart';
import 'package:duary/support/secret_key.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:duary/provider/theme_provider.dart';
import 'package:duary/provider/token_provider.dart';
import 'package:duary/repository/impl/secure_storage_impl.dart';
import 'package:duary/support/repository_container.dart';
import 'package:duary/repository/local_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  // init kakao sdk
  KakaoSdk.init(
    nativeAppKey: SecretKey.kakaoNativeAppKey,
  );

  // init Firebase(FCM)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // init Google Sign In
  final GoogleSignIn signIn = GoogleSignIn.instance;
  await signIn.initialize(
    nonce: SecretKey.oidcNonce
  );

  // pre cache splash logo
  // Native Splash Screen -> SplashScreen.dart 전환 중 로고 깜빡임 제거
  const loader = SvgAssetLoader(AssetPath.duarySplashLogo);
  await svg.cache
      .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));

  // local storage
  final LocalStorage secureStorage = SecureStorage();

  // token provider
  TokenProvider tokenProvider = TokenProvider();
  tokenProvider.secureStorage = secureStorage;

  // initialize repository container
  RepositoryContainer rc = RepositoryContainer();
  rc.initialize(secureStorage);

  // init websocket
  WebSocketHandler().init(tokenProvider);

  // init Providers
  EventProvider eventProvider = EventProvider(rc.eventRepository, rc.appleCalendarRepository);
  DuaryContext duaryContext = DuaryContext();
  duaryContext.init(
      rc.coupleRepository, rc.authRepository, rc.memberRepository);

  // init synced apple calendar
  await eventProvider.getSyncedAppleCalendar();

  runApp(Main(eventProvider: eventProvider));
}

class Main extends StatelessWidget {
  const Main({super.key, required this.eventProvider});

  final EventProvider eventProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (_) => DeepLinkManager(AppLinks())),
        ChangeNotifierProvider(create: (_) => TimeManager()),
        ChangeNotifierProvider.value(value: eventProvider)
      ],
      builder: (context, _) =>
          Consumer<ThemeProvider>(builder: (context, provider, _) {
        return MaterialApp(
            theme: provider.selected,
            debugShowCheckedModeBanner: false,
            // darkTheme: ThemeProvider.dark,
            home: const SplashScreen(),
          navigatorObservers: [routeObserver],
        );
      }),
    );
  }
}
