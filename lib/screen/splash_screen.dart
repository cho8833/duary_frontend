import 'package:duary/model/couple.dart';
import 'package:duary/provider/user_provider.dart';
import 'package:duary/screen/connect_copule_screen.dart';
import 'package:duary/screen/home_screen.dart';
import 'package:duary/support/asset_path.dart';
import 'package:duary/widget/circle_character.dart';
import 'package:duary/widget/long_character.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
  late UserProvider userProvider;

  @override
  void initState() {
    userProvider = context.read<UserProvider>();

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
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              if (userProvider.myCouple != null) {
                // Couple 연결 완료 상태면 HomeScreen 으로 route
                return const HomeScreen();
              } else {
                // Couple 연결이 되어있지 않은 경우 ConnectCoupleScreen 으로 route
              }
              return const ConnectCoupleScreen();
            }));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Couple? couple = userProvider.myCouple;
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
                  child: CircleCharacter(
                    color:
                        couple != null ? Color(couple.lover.colorCode) : null,
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
                    child: LongCharacter(
                      color: couple != null ? Color(couple.me.colorCode) : null,
                      width: 200,
                      height: 524,
                    )),
              );
            })
      ],
    ));
  }
}
