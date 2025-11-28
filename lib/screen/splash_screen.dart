import 'package:duary/provider/auth_provider.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/screen/home_screen.dart';
import 'package:duary/screen/login_screen.dart';
import 'package:duary/screen/start/start_duary_screen.dart';
import 'package:duary/support/asset_path.dart';
import 'package:duary/widget/character_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _blueSlideUpAnimation;
  late Animation<double> _yellowBounceYAnimation;
  late Animation<double> _yellowBounceXAnimation;
  final DuaryContext duaryContext = DuaryContext();

  bool _isSignInDone = false;
  bool _isAnimationDone = false;

  @override
  void initState() {
    // 로그인
    duaryContext.signInWithToken().whenComplete(() {
      _isSignInDone = true;
      whenTaskComplete();
    });

    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _yellowBounceYAnimation = Tween<double>(
      begin: -1.0,
      end: -0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    _yellowBounceXAnimation = Tween<double>(
      begin: -2.5,
      end: -1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _blueSlideUpAnimation = Tween<Offset>(
            begin: const Offset(0.0, 300.0), end: const Offset(0.0, 150.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    // route screen when animation end
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 500));
        _isAnimationDone = true;
        whenTaskComplete();
      }
    });
    super.initState();
  }

  void whenTaskComplete() async {
    if (_isAnimationDone && _isSignInDone) {
      late Widget routeScreen;
      if (duaryContext.isLoggedIn()) {
        // 커플이 생성되어 있는지 확인
        if (duaryContext.isCoupleCreated()) {
          // 커플이 생성되어 있는 경우 커플이 연결되어 있는지 확인
          routeScreen = const HomeScreen();

          // 커플이 생성되어 있지 않은 경우 StartDuaryScreen 으로 route
        } else {
          routeScreen = const StartDuaryScreen();
        }
        // 로그인되어 있지 않으면 LoginScreen 으로 route
      } else {
        routeScreen = const LoginScreen();
      }
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return routeScreen;
      }));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(Image.asset(AssetPath.blue).image, context);
    precacheImage(Image.asset(AssetPath.yellow).image, context);
    return Scaffold(
        body: Stack(
      children: [
        Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(AssetPath.duarySplashLogo)),
        AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Align(
                  alignment: Alignment(_yellowBounceXAnimation.value,
                      _yellowBounceYAnimation.value),
                  child: const Yellow(
                    color: null,
                    right: true,
                    width: 190,
                    height: 190,
                  ),
                )),
        AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Align(
                alignment: Alignment.bottomRight,
                child: Transform.translate(
                    offset: _blueSlideUpAnimation.value,
                    child: const Blue(
                      width: 200,
                      height: 524,
                    )),
              );
            })
      ],
    ));
  }
}
