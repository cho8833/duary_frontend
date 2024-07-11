import 'package:duary/widget/drawing_board/drawing_board.dart';
import 'package:duary/widget/drawing_board/drawing_controller.dart';
import 'package:flutter/material.dart';

class DiaryEditScreen extends StatefulWidget {
  const DiaryEditScreen({super.key});

  @override
  State<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  late final DrawingController controller;

  @override
  void initState() {
    super.initState();
    controller = DrawingController(
      currentColor: Colors.blue,
      currentStrokeWidth: 3.0
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DrawingBoard(
      controller: controller,
      size: const Size(500, 500),
    ));
  }
}
