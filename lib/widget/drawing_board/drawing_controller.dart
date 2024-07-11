import 'package:duary/widget/drawing_board/draw_content.dart';
import 'package:flutter/material.dart';

class DrawingController extends ChangeNotifier {
  List<DrawContent> contents = [];

  Color currentColor;
  double currentStrokeWidth;

  DrawContent? currentContent;

  DrawingController({this.currentColor = Colors.black, this.currentStrokeWidth = 1.0});

  void startLine(Offset startPoint) {
    currentContent = DrawContent([startPoint], currentColor, currentStrokeWidth);
    notifyListeners();
  }

  void updateLine(Offset point) {
    if (currentContent != null) {
      currentContent!.points.add(point);
      notifyListeners();
    }
  }

  void endLine() {
    if (currentContent != null) {
      contents.add(currentContent!);
      currentContent = null;
      notifyListeners();
    }
  }

  void setColor(Color color) {
    currentColor = color;
    notifyListeners();
  }

  void setStrokeWidth(double strokeWidth) {
    currentStrokeWidth = strokeWidth;
    notifyListeners();
  }

}