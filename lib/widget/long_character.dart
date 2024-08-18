import 'package:duary/support/asset_path.dart';
import 'package:flutter/material.dart';

// class LongCharacter extends StatelessWidget {
//   const LongCharacter(
//       {super.key, this.width, this.height, this.color});
//
//   final double? width;
//   final double? height;
//   final Color? color;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       height: height,
//       child: Image.asset(
//         AssetPath.long,
//         color: color ?? const Color(0xFF0024ff),
//         colorBlendMode: BlendMode.plus,
//       ),
//     );
//   }
// }


class LongCharacter extends StatelessWidget {
  const LongCharacter(
      {super.key, this.width, this.height, this.color, this.opacity});

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
        AssetPath.blue,
        opacity: AlwaysStoppedAnimation(opacity ?? 1),
      ),
    );
  }
}