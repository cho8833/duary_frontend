import 'package:duary/widget/drawing_board/model/sketch.dart';
import 'package:flutter/material.dart';

class SketchPainter extends CustomPainter {
  final List<Sketch> sketches;
  final Image? backgroundImage;

  const SketchPainter({
    Key? key,
    this.backgroundImage,
    required this.sketches,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // if (backgroundImage != null) {
    //   canvas.drawImageRect(
    //     backgroundImage!,
    //     Rect.fromLTWH(
    //       0,
    //       0,
    //       backgroundImage!.width.toDouble(),
    //       backgroundImage!.height.toDouble(),
    //     ),
    //     Rect.fromLTWH(0, 0, size.width, size.height),
    //     Paint(),
    //   );
    // }

    for (Sketch sketch in sketches) {
      Paint paint = Paint()
        ..color = sketch.color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = sketch.thickness;

      if (sketch is Scribble) {
        _drawScribble(canvas, paint, sketch);
      } else if (sketch is Rectangle) {
        _drawRectangle(canvas, paint, sketch);
      }

      // if (sketch.type == SketchType.scribble) {
      //   canvas.drawPath(path, paint);
      // } else if (sketch.type == SketchType.square) {
      //   canvas.drawRRect(
      //     RRect.fromRectAndRadius(rect, const Radius.circular(5)),
      //     paint,
      //   );
      // } else if (sketch.type == SketchType.line) {
      //   canvas.drawLine(firstPoint, lastPoint, paint);
      // } else if (sketch.type == SketchType.circle) {
      //   canvas.drawOval(rect, paint);
      //   // Uncomment this line if you need a PERFECT CIRCLE
      //   // canvas.drawCircle(centerPoint, radius , paint);
      // }
      // else if (sketch.type == SketchType.polygon) {
      //   Path polygonPath = Path();
      //   int sides = sketch.sides;
      //   var angle = (math.pi * 2) / sides;
      //
      //   double radian = 0.0;
      //
      //   Offset startPoint =
      //       Offset(radius * math.cos(radian), radius * math.sin(radian));
      //
      //   polygonPath.moveTo(
      //     startPoint.dx + centerPoint.dx,
      //     startPoint.dy + centerPoint.dy,
      //   );
      //   for (int i = 1; i <= sides; i++) {
      //     double x = radius * math.cos(radian + angle * i) + centerPoint.dx;
      //     double y = radius * math.sin(radian + angle * i) + centerPoint.dy;
      //     polygonPath.lineTo(x, y);
      //   }
      //   polygonPath.close();
      //   canvas.drawPath(polygonPath, paint);
      // }
    }
  }

  void _drawScribble(Canvas canvas, Paint paint, Scribble scribble) {
    final List<Offset> points = scribble.points;
    if (points.isEmpty) return;

    final path = Path();

    path.moveTo(points[0].dx, points[0].dy);
    if (points.length < 2) {
      // If the path only has one line, draw a dot.
      path.addOval(
        Rect.fromCircle(
          center: Offset(points[0].dx, points[0].dy),
          radius: 1,
        ),
      );
    } else {
      for (int i = 0; i < points.length - 1; ++i) {
        final Offset p0 = points[i];
        final Offset p1 = points[i + 1];
        path.quadraticBezierTo(
          p0.dx,
          p0.dy,
          (p0.dx + p1.dx) / 2,
          (p0.dy + p1.dy) / 2,
        );
      }
    }
    canvas.drawPath(path, paint);
  }

  void _drawRectangle(Canvas canvas, Paint paint, Rectangle rectangle) {
    canvas.drawRect(
        Rect.fromCenter(
            center: rectangle.center,
            width: rectangle.width,
            height: rectangle.height),
        paint);
  }

  @override
  bool shouldRepaint(covariant SketchPainter oldDelegate) {
    return oldDelegate.sketches != sketches;
  }
}
