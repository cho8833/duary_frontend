import 'package:duary/widget/drawing_board/sketch_board.dart';
import 'package:duary/widget/drawing_board/sketch_controller.dart';
import 'package:flutter/material.dart';

class DiaryEditScreen extends StatefulWidget {
  const DiaryEditScreen({super.key});

  @override
  State<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  late final SketchController controller;

  @override
  void initState() {
    controller = SketchController(backgroundColor: Colors.red);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SketchBoard(
      controller: controller,
      height: double.maxFinite,
      width: double.maxFinite,
    ));
  }
}
