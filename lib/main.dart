import 'package:duary/provider/event_provider.dart';
import 'package:duary/provider/user_provider.dart';
import 'package:duary/screen/splash_screen.dart';
import 'package:duary/support/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:duary/provider/auth_provider.dart';
import 'package:duary/provider/theme_provider.dart';
import 'package:duary/provider/token_provider.dart';
import 'package:duary/repository/impl/secure_storage_impl.dart';
import 'package:duary/repository/repository_container.dart';
import 'package:duary/repository/secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // secure storage
  FlutterSecureStorage ss = const FlutterSecureStorage();
  final SecureStorage secureStorage = SecureStorageImpl(ss);

  // token provider
  TokenProvider tokenProvider = TokenProvider();
  tokenProvider.secureStorage = secureStorage;

  // initialize repository container
  RepositoryContainer rc = RepositoryContainer();
  rc.initialize(secureStorage);

  // initialize auth provider
  AuthProvider authProvider = AuthProvider();
  authProvider.init(rc.authRepository);

  // check signIn
  await authProvider.checkSignIn();

  // pre cache splash logo
  // Native Splash Screen -> SplashScreen.dart 전환 중 로고 깜빡임 제거
  const loader = SvgAssetLoader(AssetPath.duarySplashLogo);
  await svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));

  // get couple
  UserProvider userProvider = UserProvider(rc.coupleRepository);
  await userProvider.getMyCouple();

  runApp(Main(
    authProvider: authProvider, userProvider: userProvider,
  ));
}

class Main extends StatelessWidget {
  const Main({super.key, required this.authProvider, required this.userProvider});

  final AuthProvider authProvider;
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    RepositoryContainer rc = RepositoryContainer();
    return MultiProvider(
      providers: [
        Provider.value(value: userProvider),
        Provider(create: (context) => EventProvider(rc.eventRepository)),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      builder: (context, _) =>
          Consumer<ThemeProvider>(builder: (context, provider, _) {
        return MaterialApp(
          theme: provider.selected,
          debugShowCheckedModeBanner: false,
          // darkTheme: ThemeProvider.dark,
          home: const SplashScreen()
        );
      }),
    );
  }
}
