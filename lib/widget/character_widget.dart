import 'dart:math';

import 'package:duary/support/asset_path.dart';
import 'package:flutter/material.dart';

class Yellow extends StatelessWidget {
  const Yellow({super.key, this.width, this.height, this.color, this.opacity});

  final double? width;
  final double? height;
  final Color? color;
  final double? opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        AssetPath.yellow,
        opacity: AlwaysStoppedAnimation(opacity ?? 1),
      ),
    );
  }
}

class Blue extends StatelessWidget {
  const Blue({super.key, this.width, this.height, this.opacity});

  final double? width;
  final double? height;
  final double? opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        AssetPath.blue,
        opacity: AlwaysStoppedAnimation(opacity ?? 1),
      ),
    );
  }
}

class CircleBlue extends StatelessWidget {
  const CircleBlue({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(AssetPath.blueCircle),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = size.shortestSide / 2;
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class AnimatingBlue extends StatefulWidget {
  const AnimatingBlue(
      {super.key, required this.width, required this.height, this.opacity});

  final double width;
  final double height;
  final double? opacity;

  @override
  State<AnimatingBlue> createState() => _AnimatingBlueState();
}

class _AnimatingBlueState extends State<AnimatingBlue>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  static const double _maxMoveRange = 10;
  final Random _random = Random();

  double _targetXDistance = 0.0;

  double _targetYDistance = 0.0;

  double _getRandomDistance() {
    return _maxMoveRange * _random.nextDouble();
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1))
      ..repeat(reverse: true);

    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
