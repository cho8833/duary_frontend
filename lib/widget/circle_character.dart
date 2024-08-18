import 'package:duary/support/asset_path.dart';
import 'package:flutter/material.dart';

// class CircleCharacter extends StatelessWidget {
//   const CircleCharacter({super.key, this.width, this.height, this.color, this.opacity});
//
//   final double? width;
//   final double? height;
//   final Color? color;
//   final double? opacity;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       height: height,
//       child: Image.asset(
//         AssetPath.circle,
//         color: color ?? const Color(0xFFff9000),
//         colorBlendMode: BlendMode.plus,
//       ),
//     );
//   }
// }

class CircleCharacter extends StatelessWidget {
  const CircleCharacter({super.key, this.width, this.height, this.color, this.opacity});

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
