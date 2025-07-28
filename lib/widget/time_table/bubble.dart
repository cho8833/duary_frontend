
import 'package:duary/model/enums/character.dart';
import 'package:duary/widget/character_widget.dart';
import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  const Bubble(
      {super.key,
        required this.character,
        required this.width,
        required this.height,
        required this.isLeft,
        required this.content});

  final double width;

  final double height;

  final Character character;

  final Widget content;

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: character.bubbleColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(2, 2))
          ]),
      child: ClipPath(
        clipper: RoundedClipper(),
        child: Stack(
          children: [
            content,
            Positioned(
                bottom: -21,
                right: isLeft ? 5 : null,
                left: isLeft ? null : 5,
                child: _CharacterImage(
                    isTogether: character == Character.together,
                    isLeft: isLeft,
                    character: character))
          ],
        ),
      ),
    );
  }
}

class _CharacterImage extends StatelessWidget {
  const _CharacterImage(
      {required this.isTogether,
        required this.isLeft,
        required this.character});

  final bool isTogether;

  final bool isLeft;

  final Character character;

  @override
  Widget build(BuildContext context) {
    if (isTogether) {
      if (isLeft) {
        return const Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Yellow(
              width: 39,
              height: 39,
              opacity: 0.2,
            ),
            Blue(
              width: 39,
              height: 67,
              opacity: 0.2,
            ),
          ],
        );
      } else {
        return const Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Blue(
              width: 39,
              height: 67,
              opacity: 0.2,
            ),
            Yellow(
              width: 39,
              height: 39,
              opacity: 0.2,
            ),
          ],
        );
      }
    } else if (character == Character.blue) {
      return const Blue(
        width: 39,
        height: 67,
        opacity: 0.2,
      );
    } else {
      return const Yellow(
        width: 39,
        height: 39,
        opacity: 0.2,
      );
    }
  }
}

class RoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 20;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    return Path()..addRRect(rRect);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}