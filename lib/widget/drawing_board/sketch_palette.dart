import 'package:duary/widget/drawing_board/model/drawing_mode.dart';
import 'package:duary/widget/drawing_board/sketch_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SketchPalette extends StatefulWidget {
  const SketchPalette({super.key, required this.controller});

  final SketchController controller;

  @override
  State<SketchPalette> createState() => _SketchPaletteState();
}

class _SketchPaletteState extends State<SketchPalette> {
  static const double _iconSize = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(42, 10, 32, 10),
      width: double.maxFinite,
      color: Colors.white,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              child: SvgPicture.asset(
                "asset/pen-tool.svg",
                width: _iconSize,
                height: _iconSize,
              ),
            ),
            GestureDetector(
              child: Image.asset("asset/highlighter.png")
            ),
            GestureDetector(
              onTap: () {
                widget.controller.currentMode.value = DrawingMode.eraser;
              },
              child:  Image.asset(
                "asset/eraser.png"
              )
            ),
            GestureDetector(
              child: SvgPicture.asset(
                "asset/picture.svg",
                width: _iconSize,
                height: _iconSize,
              ),
            ),
            const VerticalDivider(
              thickness: 2,
              width: 20,
              color: Color.fromRGBO(234, 234, 234, 1.0)
            ),
            GestureDetector(
              child: Image.asset("asset/color-palette.png"),
            ),
          ],
        ),
      ),
    );
  }
}
