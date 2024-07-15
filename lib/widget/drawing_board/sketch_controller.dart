import 'package:duary/widget/drawing_board/model/drawing_mode.dart';
import 'package:duary/widget/drawing_board/model/sketch.dart';
import 'package:flutter/material.dart';

class SketchController {
  ValueNotifier<Sketch?> currentSketch = ValueNotifier(null);
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

  void onPointerDown(Offset offset) {
    currentSketch.value = Sketch.fromDrawingMode(
        Sketch(
            points: [offset],
            size: currentMode.value == DrawingMode.eraser
                ? eraserSize.value
                : strokeSize.value,
            color: currentMode.value == DrawingMode.eraser
                ? backgroundColor.value
                : currentColor.value,
            sides: polygonSides.value),
        currentMode.value,
        filled.value);
  }

  void onPointerMove(Offset offset) {
    if (currentSketch.value == null) {
      return;
    }
    currentSketch.value!.points.add(offset);
    currentSketch.value = Sketch.fromDrawingMode(
        Sketch(
            points: currentSketch.value!.points,
            size: currentMode.value == DrawingMode.eraser
                ? eraserSize.value
                : strokeSize.value,
            color: currentMode.value == DrawingMode.eraser
                ? backgroundColor.value
                : currentColor.value,
            sides: polygonSides.value),
        currentMode.value,
        filled.value);
  }

  void onPointerUp() {
    if (currentSketch.value != null) {
      sketches.value.add(currentSketch.value!);
      sketches.value = List<Sketch>.from(sketches.value);
      currentSketch.value = null;
    }
  }
}
