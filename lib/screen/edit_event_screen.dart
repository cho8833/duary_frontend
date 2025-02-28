import 'package:duary/model/event.dart';
import 'package:duary/widget/sub_page_app_bar.dart';
import 'package:flutter/material.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key, this.event});

  final Event? event;

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {

  late final bool isEdit;

  @override
  void initState() {
    super.initState();

    isEdit = widget.event != null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubPageAppBar(
          appBarObj: AppBar(),
          title: Text(
             isEdit ? "일정 수정" : "일정 생성",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xFFFE8F00),
            ),
          )),

    );
  }
}
