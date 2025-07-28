import 'package:duary/provider/duary_context.dart';
import 'package:duary/screen/start/connect_copule_screen.dart';
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
  late DuaryContext duaryContext;

  late Future<void> signInFuture;

  bool _isSIgnInDone = false;
  bool _isAnimationDone = false;

  @override
  void initState() {
    duaryContext = DuaryContext();

    // 로그인
    signInFuture = duaryContext.signInWithToken().whenComplete(() {
      _isSIgnInDone = true;
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
        _isAnimationDone = true;
        await Future.delayed(const Duration(milliseconds: 500));
        whenTaskComplete();
      }
    });
    super.initState();
  }

  void whenTaskComplete() {
    if (_isAnimationDone && _isSIgnInDone) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        // 로그인되어 있으면
        if (duaryContext.isLoggedIn()) {
          // 커플이 생성되어 있는지 확인
          if (duaryContext.isCoupleCreated()) {
            // 커플이 생성되어 있는 경우 커플이 연결되어 있는지 확인
            if (duaryContext.isCoupleConnected()) {
              // Couple 연결 완료 상태면 HomeScreen 으로 route
              return const HomeScreen();
            } else {
              // Couple 연결이 되어있지 않은 경우 ConnectCoupleScreen 으로 route
              return const ConnectCoupleScreen();
            }
            // 커플이 생성되어 있지 않은 경우 StartDuaryScreen 으로 route
          } else {
            return const StartDuaryScreen();
          }
          // 로그인되어 있지 않으면 LoginScreen 으로 route
        } else {
          return const LoginScreen();
        }
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
