import 'package:duary/widget/drawing_board/draw_content.dart';
import 'package:duary/widget/drawing_board/drawing_controller.dart';
import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final DrawingController controller;

  DrawingPainter(this.controller) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..strokeCap = StrokeCap.round;

    for (DrawContent content in controller.contents) {
      paint
        ..color = content.color
        ..strokeWidth = content.strokeWidth;

      for (int i = 0; i < content.points.length - 1; i++) {
        canvas.drawLine(content.points[i], content.points[i + 1], paint);
      }
    }

    if (controller.currentContent != null) {
      paint
        ..color = controller.currentContent!.color
        ..strokeWidth = controller.currentContent!.strokeWidth;

      for (int i = 0; i < controller.currentContent!.points.length - 1; i++) {
        canvas.drawLine(controller.currentContent!.points[i],
            controller.currentContent!.points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
