import 'package:duary/widget/drawing_board/model/sketch.dart';
import 'package:duary/widget/drawing_board/sketch_board.dart';
import 'package:duary/widget/drawing_board/sketch_controller.dart';
import 'package:duary/widget/drawing_board/sketch_palette.dart';
import 'package:duary/widget/sub_page_app_bar.dart';
import 'package:flutter/material.dart';

class DiaryEditScreen extends StatefulWidget {
  const DiaryEditScreen({super.key, required this.title});

  final String title;

  @override
  State<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  late final SketchController controller;

  @override
  void initState() {
    controller = SketchController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SubPageAppBar(
          appBarObj: AppBar(),
          title: widget.title,
          backgroundColor: const Color.fromRGBO(254, 251, 238, 1.0),
          trailingBuilder: (context) => GestureDetector(
              onTap: controller.rollback,
              child: ValueListenableBuilder<List<Sketch>>(
                builder: (context, sketches, _) {
                  return Icon(Icons.settings_backup_restore,
                      color: controller.sketches.value.isNotEmpty
                          ? Colors.black
                          : Colors.grey);
                }, valueListenable: controller.sketches,
              )),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SketchPalette(controller: controller),
              Expanded(
                child: SketchBoard(
                  controller: controller,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ));
  }
}
