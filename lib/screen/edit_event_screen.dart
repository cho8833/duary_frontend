import 'package:duary/model/event.dart';
import 'package:duary/support/asset_path.dart';
import 'package:duary/widget/base_app_bar.dart';
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

  String title = "";
  bool isTogether = false;
  bool allDay = false;

  @override
  void initState() {
    super.initState();
    isEdit = widget.event != null;
  }

  Widget _subTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 18, color: Color(0xFF323232), fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBase(
        appBarObj: AppBar(),
        centerBuilder: (context) =>
            Text(
              isEdit ? "일정 수정" : "일정 생성",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Color(0xFFFE8F00),
              ),
            ),
        trailingBuilder: (context) =>
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: Color(0xFF9A9A9A),
                )),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _subTitle("일정 제목"),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: title,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (text) {
                title = text;
              },
              decoration: InputDecoration(
                  hintText: "일정 제목을 입력해주세요",
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFFD0D0D0)),
                  fillColor: const Color(0xFFF3F3F3),
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  border: OutlineInputBorder(
                      borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(10))),
            ),

            const SizedBox(height: 11),

            // 공동 일정으로 설정하기
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  isTogether = !isTogether;
                });
              },
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.task_alt,
                    color: isTogether
                        ? const Color(0xFFFFBD64)
                        : const Color(0xFFD0D0D0),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "공동 일정으로 설정하기",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isTogether
                            ? const Color(0xFFFFBD64)
                            : const Color(0xFFD0D0D0)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 37,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _subTitle("진행 시간"),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      allDay = !allDay;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.task_alt,
                        color: allDay
                            ? const Color(0xFFFFBD64)
                            : const Color(0xFFD0D0D0),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                          "하루종일",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: allDay
                                  ? const Color(0xFFFFBD64)
                                  : const Color(0xFFD0D0D0))),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
