import 'dart:io';
import 'dart:math';

import 'package:duary/support/asset_path.dart';
import 'package:flutter/material.dart';

class Yellow extends StatelessWidget {
  const Yellow({super.key, this.width, this.height, this.color, this.opacity, this.right = false});

  final double? width;
  final double? height;
  final Color? color;
  final double? opacity;

  final bool right;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Transform(
        transform: Matrix4.rotationY(right ? 0 : pi),
        alignment: Alignment.center,
        child: Image.asset(
          AssetPath.yellow,
          opacity: AlwaysStoppedAnimation(opacity ?? 1),
        ),
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
  const CircleBlue({super.key, required this.size, this.right = false});

  final double size;

  final bool right;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Transform(
        alignment: Alignment.center,
          transform: Matrix4.rotationY(right ? pi : 0),
          child: Image.asset(AssetPath.blueCircle)
      ),
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
