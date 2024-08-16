import 'package:duary/widget/drawing_board/model/drawing_mode.dart';
import 'package:flutter/material.dart';

class Sketch {
  final Color color; // *
  final double thickness; // *
  final DrawingMode drawingMode;

  Sketch({
    required this.drawingMode,
    required this.color,
    required this.thickness,
  });

  factory Sketch.fromDrawingMode(
    Sketch sketch,
    DrawingMode drawingMode,
    bool filled,
  ) {
    return Sketch(
      drawingMode: drawingMode,
      color: sketch.color,
      thickness: sketch.thickness,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color.toHex(),
      'size': thickness,
    };
  }

  factory Sketch.fromJson(Map<String, dynamic> json) {
    return Sketch(
      drawingMode: DrawingMode.fromJson(json['drawingMode']),
      color: (json['color'] as String).toColor(),
      thickness: json['size'],
    );
  }
}

enum SketchType { scribble, line, square, circle, polygon }

extension SketchTypeX on SketchType {
  String toRegularString() => toString().split('.')[1];
}

extension SketchTypeExtension on String {
  SketchType toSketchTypeEnum() =>
      SketchType.values.firstWhere((e) => e.toString() == 'SketchType.$this');
}

extension ColorExtension on String {
  Color toColor() {
    var hexColor = replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    if (hexColor.length == 8) {
      return Color(int.parse('0x$hexColor'));
    } else {
      return Colors.black;
    }
  }
}

extension ColorExtensionX on Color {
  String toHex() => '#${value.toRadixString(16).substring(2, 8)}';
}

class Scribble extends Sketch {
  final List<Offset> points;

  Scribble(
      { required super.drawingMode,
        required this.points,
      required super.thickness,
      required super.color});

  factory Scribble.fromJson(
          Map<String, dynamic> json, double thickness, Color color) =>
      Scribble(
        drawingMode: DrawingMode.fromJson(json['drawingMode']),
          points: (json['points'] as List)
              .map((e) => Offset(e['dx'], e['dy']))
              .toList(),
          thickness: thickness,
          color: color);

}

class Rectangle extends Sketch {
  Offset center;
  double width;
  double height;

  Rectangle(
      {required super.drawingMode,
        required this.center,
      required this.width,
      required this.height,
      required super.thickness,
      required super.color,});

  factory Rectangle.fromJson(
      Map<String, dynamic> json, double thickness, Color color) {
    return Rectangle(
      drawingMode: DrawingMode.fromJson(json['drawingMode']),
        center: Offset((json['center_x'] as num).toDouble(),
            (json['center_y'] as num).toDouble()),
        width: (json['width'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
        thickness: thickness,
        color: color);
  }
}

class Circle extends Sketch {
  double centerX;
  double centerY;
  double radius;

  Circle(
      {required super.drawingMode,
        required this.centerX,
      required this.centerY,
      required this.radius,
      required super.thickness,
      required super.color, });

  factory Circle.fromJson(
          Map<String, dynamic> json, double thickness, Color color) =>
      Circle(
        drawingMode: DrawingMode.fromJson(json['drawingMode']),
          centerX: (json['centerX'] as num).toDouble(),
          centerY: (json['centerY'] as num).toDouble(),
          radius: (json['radius'] as num).toDouble(),
          thickness: thickness,
          color: color);
}
