import 'package:duary/widget/drawing_board/model/sketch.dart';
import 'package:duary/widget/drawing_board/sketch_controller.dart';
import 'package:duary/widget/drawing_board/sketch_painter.dart';
import 'package:flutter/material.dart' hide Image;

class SketchBoard extends StatelessWidget {
  const SketchBoard(
      {super.key, this.height, this.width, required this.controller});

  final double? height;
  final double? width;
  final SketchController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: width,
      height: height,
      color: controller.backgroundColor.value,
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5.0,
        boundaryMargin: const EdgeInsets.all(20),
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              buildAllSketches(context),
              buildCurrentPath(context),
            ],
          ),
        ),
      ),
    );
  }

  void onPointerDown(PointerDownEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    controller.onPointerDown(offset);
  }

  void onPointerMove(PointerMoveEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    controller.onPointerMove(offset);
  }

  void onPointerUp(PointerUpEvent details) {
    controller.onPointerUp();
  }

  Widget buildAllSketches(BuildContext context) {
    return ValueListenableBuilder<List<Sketch>>(
      valueListenable: controller.sketches,
      builder: (context, sketches, _) {
        return RepaintBoundary(
          child: SizedBox(
            width: width,
            // height: height,
            child: CustomPaint(
              painter: SketchPainter(
                sketches: sketches,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCurrentPath(BuildContext context) {
    return Listener(
      onPointerDown: (details) => onPointerDown(details, context),
      onPointerMove: (details) => onPointerMove(details, context),
      onPointerUp: onPointerUp,
      child: ValueListenableBuilder<Sketch?>(
        valueListenable: controller.currentSketch,
        builder: (context, sketch, child) {
          return RepaintBoundary(
            child: SizedBox(
              width: width,
              height: height,
              child: CustomPaint(
                painter: SketchPainter(
                  sketches: sketch == null ? [] : [sketch],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
