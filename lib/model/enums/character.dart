import 'dart:ui';
import 'package:duary/widget/character_widget.dart';
import 'package:flutter/material.dart';


enum Character {
  blue("BLUE", "파랑이", Color(0xFF405BFF), Color(0xFF0024ff), Color(0xFFCED5FF), Color(0xFF2E3E9C), Color(0xFF00072E)),
  yellow("YELLOW", "노랑이", Color(0xFFFFA93A), Color(0xFFFFA93A), Color(0xFFFFEBD1), Color(0xFFA36E29), Color(0xFF3C2200)),
  together("TOGETHER", "함께",Color(0xFFFF488A), Color(0xFFFF488A), Color(0xFFFFE5EE), Color(0xFF842143), Color(0xFF350013));

  final String name;
  
  final Color characterColor;
  
  final Color strokeColor;

  final Color bubbleColor;
  
  final Color fontColor;
  
  final Color fontBlackColor;

  final String title;

  const Character(this.name, this.title, this.characterColor, this.strokeColor, this.bubbleColor, this.fontColor, this.fontBlackColor);

  @override
  String toString() {
    return title;
  }

  String toJson() {
    return name;
  }

  factory Character.fromJson(String json) {
    return Character.values.firstWhere((element) => element.toJson() == json);
  }

  static Widget characterWidget(Character character, {required double width, double? height}) {
    switch (character) {
      case Character.blue:
        return Blue(
          width: width,
          height: height,
        );
      case Character.yellow:
        return Yellow(
          width: width,
          height: height,
        );
      default:
        throw Exception();
    }
  }

  static Widget characterCircleWidget(Character character, {required double size}) {
    switch (character) {
      case Character.blue:
        return CircleBlue(size: size);
      case Character.yellow:
        return Yellow(
          width: size,
          height: size,
        );
      default:
        throw Exception();
    }
  }
}