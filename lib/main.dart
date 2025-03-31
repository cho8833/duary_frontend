import 'package:duary/firebase_options.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/screen/splash_screen.dart';
import 'package:duary/support/asset_path.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:duary/provider/auth_provider.dart';
import 'package:duary/provider/theme_provider.dart';
import 'package:duary/provider/token_provider.dart';
import 'package:duary/repository/impl/secure_storage_impl.dart';
import 'package:duary/repository/repository_container.dart';
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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
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

  // initialize auth provider
  AuthProvider authProvider = AuthProvider();
  authProvider.init(rc.authRepository);
  DuaryContext duaryContext = DuaryContext(rc.eventRepository, rc.coupleRepository);

  // check signIn
  await authProvider.checkSignIn().then((_) async {
    if (authProvider.me != null) {
      await duaryContext.getMyCouple(authProvider.me!);
    }
  });

  runApp(Main(
    duaryContext: duaryContext,
  ));
}

class Main extends StatelessWidget {
  const Main(
      {super.key, required this.duaryContext});
  final DuaryContext duaryContext;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: duaryContext),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
