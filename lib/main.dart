import 'package:duary/screen/diary_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:duary/provider/auth_provider.dart';
import 'package:duary/provider/member_provider.dart';
import 'package:duary/provider/theme_provider.dart';
import 'package:duary/provider/token_provider.dart';
import 'package:duary/repository/impl/secure_storage_impl.dart';
import 'package:duary/repository/repository_container.dart';
import 'package:duary/repository/secure_storage.dart';
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

  // initialize router

  runApp(Main(
    authProvider: authProvider,
  ));
}

class Main extends StatelessWidget {
  const Main({super.key, required this.authProvider});

  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    RepositoryContainer rc = RepositoryContainer();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (_) => MemberProvider(rc.memberRepository))
      ],
      builder: (context, _) =>
          Consumer<ThemeProvider>(builder: (context, provider, _) {
        return MaterialApp(
          theme: provider.selected,
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeProvider.dark,
          home: const DiaryEditScreen(title: "해운대 데이트",),
        );
      }),
    );
  }
}
