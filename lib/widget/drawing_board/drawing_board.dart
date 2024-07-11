import 'package:duary/widget/drawing_board/drawing_controller.dart';
import 'package:duary/widget/drawing_board/drawing_painter.dart';
import 'package:flutter/material.dart';

class DrawingBoard extends StatelessWidget {
  const DrawingBoard({super.key, required this.controller, required this.size});

  final DrawingController controller;

  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset startPoint = renderBox.globalToLocal(details.globalPosition);
        controller.startLine(startPoint);
      },
      onPanUpdate: (details) {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset point = renderBox.globalToLocal(details.globalPosition);
        controller.updateLine(point);
      },
      onPanEnd: (details) {
        controller.endLine();
      },
      child: CustomPaint(
        size: size,
        painter: DrawingPainter(controller),
      ),
    );
  }
}
