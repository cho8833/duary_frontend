import 'package:duary/widget/button_base.dart';
import 'package:flutter/material.dart';

class DuaryTextInputBox extends StatefulWidget {
  const DuaryTextInputBox(
      {super.key,  this.hintText, required this.onChange,  this.initialValue});

  final String? hintText;

  final String? initialValue;

  final void Function(String) onChange;

  @override
  State<DuaryTextInputBox> createState() => _DuaryTextInputBoxState();
}

class _DuaryTextInputBoxState extends State<DuaryTextInputBox> {

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.initialValue ?? "";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        onChanged: widget.onChange,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF3F3F3F),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
