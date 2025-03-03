import 'package:duary/model/event.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:flutter/material.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key, this.event});

  final Event? event;

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late final bool isEdit;

  String? title;
  String? location;
  String? meetWith;
  String? content;
  bool isTogether = false;
  bool allDay = false;
  Repeat? repeat;

  @override
  void initState() {
    super.initState();
    isEdit = widget.event != null;

    if (isEdit) {
      Event event = widget.event!;
      title = event.title;
      location = event.location;
      meetWith = event.meetWith;
      content = event.content;
      isTogether = event.isTogether;
      allDay = event.isAllDay;
      repeat = event.repeat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBase(
        appBarObj: AppBar(),
        centerBuilder: (context) => Text(
          isEdit ? "일정 수정" : "일정 생성",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFFFE8F00),
          ),
        ),
        trailingBuilder: (context) => GestureDetector(
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
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _subTitle("일정 제목"),
                    const SizedBox(
                      height: 10,
                    ),
                    _textFieldBox(
                        initialValue: title,
                        hintText: "일정 제목을 입력해주세요",
                        onChange: (text) => title = text),

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

                    const SizedBox(
                      height: 37,
                    ),

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
                              Text("하루종일",
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
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "시작",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF646464)),
                        ),
                        Row(
                          children: [
                            _timeBox(text: "2024. 9. 11. 수", onTap: () {}),
                            const SizedBox(
                              width: 5,
                            ),
                            _timeBox(text: "오후 10:00", onTap: () {})
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "종료",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF646464)),
                        ),
                        Row(
                          children: [
                            _timeBox(text: "2024. 9. 11. 수", onTap: () {}),
                            const SizedBox(
                              width: 5,
                            ),
                            _timeBox(text: "오후 11:00", onTap: () {})
                          ],
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    _subTitle("반복"),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF3F3F3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            repeat?.frequency.title ?? "일정 반복 안함",
                            style: TextStyle(
                                fontSize: 16,
                                color: repeat != null
                                    ? const Color(0xFF333333)
                                    : const Color(0xFFD0D0D0)),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFFB6B6B6),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    _subTitle("장소"),
                    const SizedBox(
                      height: 10,
                    ),
                    _textFieldBox(
                        initialValue: location,
                        hintText: "일정이 진행되는 장소를 입력해주세요",
                        onChange: (text) => location = text),

                    const SizedBox(
                      height: 30,
                    ),

                    _subTitle("만나는 사람"),
                    const SizedBox(
                      height: 10,
                    ),
                    _textFieldBox(
                        initialValue: meetWith,
                        hintText: "만나는 사람을 입력해주세요",
                        onChange: (text) => meetWith = text),

                    const SizedBox(
                      height: 30,
                    ),

                    _subTitle("메모"),
                    const SizedBox(
                      height: 10,
                    ),
                    _textFieldBox(
                        initialValue: content,
                        hintText: "메모를 입력해주세요",
                        onChange: (text) => content = text,
                        maxLines: 4),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFBD64),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  isEdit ? "일정 수정하기" : "새 일정 등록하기",
                  style: const TextStyle(
                      color: Color(0xFF573200),
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 18, color: Color(0xFF323232), fontWeight: FontWeight.w600),
    );
  }

  Widget _timeBox({required String text, required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF3F3F3),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333)),
        ),
      ),
    );
  }

  Widget _textFieldBox(
      {String? initialValue,
      required String hintText,
      required void Function(String) onChange,
      int? maxLines}) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChange,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFFD0D0D0)),
          fillColor: const Color(0xFFF3F3F3),
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          border: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(10))),
    );
  }
}
