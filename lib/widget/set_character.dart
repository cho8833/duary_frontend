import 'package:duary/support/asset_path.dart';
import 'package:flutter/material.dart';

class SetCharacter extends StatelessWidget {
  const SetCharacter({super.key, this.width, this.height, this.color, this.opacity});

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
        AssetPath.set,
        opacity: AlwaysStoppedAnimation(opacity ?? 1),
      ),
    );
  }
}
