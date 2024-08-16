import 'dart:convert';

import 'package:duary/widget/drawing_board/model/drawing_mode.dart';
import 'package:duary/widget/drawing_board/model/sketch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SketchController {
  ValueNotifier<Scribble?> currentSketch = ValueNotifier(null);
  ValueNotifier<DrawingMode> currentMode = ValueNotifier(DrawingMode.pencil);
  ValueNotifier<double> strokeSize = ValueNotifier(5.0);
  ValueNotifier<Color> currentColor = ValueNotifier(Colors.black);
  ValueNotifier<bool> filled = ValueNotifier(true);
  ValueNotifier<double> eraserSize = ValueNotifier(5.0);
  ValueNotifier<Color> backgroundColor;
  ValueNotifier<int> polygonSides = ValueNotifier(3);
  ValueNotifier<List<Sketch>> sketches = ValueNotifier([]);

  SketchController({Color? backgroundColor})
      : backgroundColor = ValueNotifier(backgroundColor ?? Colors.white);

  static const platform = MethodChannel('com.example.duary_frontend/opencv');

  void onPointerDown(Offset offset) {
    currentSketch.value = Scribble(
      drawingMode: currentMode.value,
      points: [offset],
      thickness: currentMode.value == DrawingMode.eraser
          ? eraserSize.value
          : strokeSize.value,
      color: currentMode.value == DrawingMode.eraser
          ? backgroundColor.value
          : currentColor.value,
    );
  }

  void onPointerMove(Offset offset) {
    if (currentSketch.value == null) {
      return;
    }
    currentSketch.value!.points.add(offset);
    currentSketch.value = Scribble(
      drawingMode: currentMode.value,

        points: currentSketch.value!.points,
      thickness: currentMode.value == DrawingMode.eraser
          ? eraserSize.value
          : strokeSize.value,
      color: currentMode.value == DrawingMode.eraser
          ? backgroundColor.value
          : currentColor.value,);
  }

  void onPointerUp() async {
    if (currentSketch.value != null) {
      if (currentSketch.value!.points.length < 2) {
        sketches.value.add(currentSketch.value!);
        sketches.value = List<Sketch>.from(sketches.value);
        return;
      }
      final String pointsJson = jsonEncode((currentSketch.value!)
          .points
          .map((p) => [p.dx, p.dy])
          .toList());
      final Size size =
          _calculateShapeSize(currentSketch.value!.points);
      final result = await platform.invokeMethod('detectShapeFromPoints', {
        'points': pointsJson,
        'width': size.width,
        'height': size.height,
      });
      final List<dynamic> shapes = jsonDecode(result);
      if (shapes.isEmpty) {
        sketches.value.add(currentSketch.value!);
        sketches.value = List<Sketch>.from(sketches.value);
        return;
      }
      Map<String, dynamic> shape = shapes.first;
      if (shape['type'] == 'rectangle') {
        sketches.value.add(Rectangle.fromJson(
            shape, currentSketch.value!.thickness, currentSketch.value!.color));
      } else if (shapes.first['type'] == 'circle') {}
      sketches.value = List<Sketch>.from(sketches.value);
      currentSketch.value = null;
    }
  }

  void rollback() {
    if (sketches.value.isNotEmpty) {
      sketches.value.removeLast();
      sketches.value = List<Sketch>.from(sketches.value);
    }
  }

  Size _calculateShapeSize(List<Offset> points) {
    if (points.isEmpty) return Size.zero;

    double minX = points.first.dx;
    double maxX = points.first.dx;
    double minY = points.first.dy;
    double maxY = points.first.dy;

    for (var point in points) {
      if (point.dx < minX) minX = point.dx;
      if (point.dx > maxX) maxX = point.dx;
      if (point.dy < minY) minY = point.dy;
      if (point.dy > maxY) maxY = point.dy;
    }

    return Size(maxX - minX, maxY - minY);
  }
}
