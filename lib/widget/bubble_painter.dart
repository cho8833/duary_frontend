import 'dart:math';

import 'package:duary/model/enums/character.dart';
import 'package:flutter/material.dart';

class SpeechBubblePainter extends CustomPainter {
  final bool isLeft;
  final Character character;

  SpeechBubblePainter({required this.isLeft, required this.character});

  static const double _triangleXPos = 13;
  static const double _triangleYPos1 = 10;
  static const double _triangleYPos2 = 26;
  static const double _bubbleWidthCorr = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = character.bubbleColor
      ..style = PaintingStyle.fill;
    final Paint strokePaint = Paint()
      ..color = character.strokeColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw the rounded rectangle
    if (!isLeft) {
      // Draw the triangle on the left
      const Offset p1 = Offset(_triangleXPos, _triangleYPos1);
      const Offset p2 = Offset(_triangleXPos, _triangleYPos2);
      const Offset p3 = Offset(0, (_triangleYPos1 + _triangleYPos2) / 2);
      final Path trianglePath = createRoundedTriangle(p1, p2, p3, 1);

      // If flipped, draw the rectangle on the right
      final RRect roundedRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
            _bubbleWidthCorr, 0, size.width - _bubbleWidthCorr, size.height),
        const Radius.circular(20),
      );

      canvas.drawRRect(roundedRect, paint);
      canvas.drawPath(trianglePath, paint);

      // 사각형과 삼각형의 합집합(Union) 경로 생성
      final Path rectPath = Path()..addRRect(roundedRect);
      final Path unionPath = Path.combine(
        PathOperation.union,
        rectPath,
        trianglePath,
      );

      canvas.drawPath(unionPath, strokePaint);
    } else {
      // If not flipped, draw the rectangle on the left
      final RRect roundedRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width - _bubbleWidthCorr, size.height),
        const Radius.circular(20),
      );

      // Draw the triangle on the right
      final Offset p1 = Offset(size.width - _triangleXPos, _triangleYPos1);
      final Offset p2 = Offset(size.width - _triangleXPos, _triangleYPos2);
      final Offset p3 =
      Offset(size.width, (_triangleYPos1 + _triangleYPos2) / 2);
      final Path trianglePath = createRoundedTriangle(p1, p2, p3, 1);

      canvas.drawRRect(roundedRect, paint);
      canvas.drawPath(trianglePath, paint);

      // 사각형과 삼각형의 합집합(Union) 경로 생성
      final Path rectPath = Path()..addRRect(roundedRect);
      final Path unionPath = Path.combine(
        PathOperation.union,
        rectPath,
        trianglePath,
      );

      canvas.drawPath(unionPath, strokePaint);
    }
  }

  Path createRoundedTriangle(Offset p1, Offset p2, Offset p3, double radius) {
    final List<Offset> points = [p1, p2, p3];
    final Path path = Path();

    for (int i = 0; i < points.length; i++) {
      final Offset prev = points[(i + points.length - 1) % points.length];
      final Offset current = points[i];
      final Offset next = points[(i + 1) % points.length];

      // 벡터 계산
      final Offset v1 = (prev - current);
      final Offset v2 = (next - current);
      final double v1Length = v1.distance;
      final double v2Length = v2.distance;
      final Offset v1Unit = v1 / v1Length;
      final Offset v2Unit = v2 / v2Length;

      // 현재 꼭짓점에서 벗어날 거리. 삼각형에서는 너무 길어지면 모서리가 서로 겹칠 수 있으니 각 변의 길이의 절반 이하로 제한.
      // 코사인 법칙을 이용해 각도의 절반에 해당하는 탄젠트 값을 사용합니다.
      final double dot = v1Unit.dx * v2Unit.dx + v1Unit.dy * v2Unit.dy;
      final double clampedDot = dot.clamp(-1.0, 1.0);
      final double angle = acos(clampedDot);
      final double distance = radius / tan(angle / 2);

      final double d1 = min(distance, v1Length / 2);
      final double d2 = min(distance, v2Length / 2);

      // 각 변에서 둥글게 깎일 시작과 끝 점 계산
      final Offset start = current + v1Unit * d1;
      final Offset end = current + v2Unit * d2;

      if (i == 0) {
        path.moveTo(start.dx, start.dy);
      } else {
        path.lineTo(start.dx, start.dy);
      }
      // 현재 꼭짓점을 제어점으로 quadratic bezier 곡선을 그려 둥글게 만듭니다.
      path.quadraticBezierTo(current.dx, current.dy, end.dx, end.dy);
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant SpeechBubblePainter oldDelegate) {
    return false;
  }
}

class LeftBottomRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double leftOffset = SpeechBubblePainter._triangleXPos;
    const double radius = 10;
    final Path path = Path();

    // 시작점: (leftOffset, 0)
    path.moveTo(leftOffset, 0);
    // 상단: 오른쪽 끝까지 직선
    path.lineTo(size.width, 0);
    // 우측: 아래쪽 끝까지 직선
    path.lineTo(size.width, size.height);
    // 하단: 왼쪽으로 이동 (둥근 모서리 시작점)
    path.lineTo(leftOffset + radius, size.height);
    // 왼쪽 하단 둥근 모서리: (leftOffset+radius, size.height)에서 (leftOffset, size.height - radius)까지의 90도 호
    path.arcToPoint(
      Offset(leftOffset, size.height - radius),
      radius: const Radius.circular(radius),
      // 사각형 내부로 그리려면 (시계 반대방향) false 설정
      clockwise: true,
    );
    // 좌측: 위쪽 끝까지 직선
    path.lineTo(leftOffset, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class RightBottomRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 10;
    const double rightOffset = SpeechBubblePainter._triangleXPos;
    final Path path = Path();

    // 시작점: 왼쪽 상단
    path.moveTo(0, 0);
    // 상단: 왼쪽 상단에서 오른쪽 상단까지 직선
    path.lineTo(size.width - rightOffset, 0);
    // 우측: 오른쪽 상단에서 오른쪽 하단의 둥근 시작점까지 직선
    path.lineTo(size.width - rightOffset, size.height - radius);
    // 오른쪽 하단 둥근 모서리: (size.width, size.height - radius)에서 (size.width - radius, size.height)로 arc
    path.arcToPoint(
      Offset(size.width -rightOffset - radius, size.height),
      radius: const Radius.circular(radius),
      clockwise: true,
    );
    // 하단: arc 종료점에서 왼쪽 하단까지 직선
    path.lineTo(0, size.height);
    // 좌측: 왼쪽 하단에서 시작점(0,0)까지 직선
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}