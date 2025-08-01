import 'package:duary/provider/duary_context.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/button_base.dart';
import 'package:duary/widget/duary_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditRelationDateScreen extends StatefulWidget {
  const EditRelationDateScreen({super.key});

  @override
  State<EditRelationDateScreen> createState() => _EditRelationDateScreenState();
}

class _EditRelationDateScreenState extends State<EditRelationDateScreen> {
  DuaryContext duaryContext = DuaryContext();
  late DateTime relationDate;

  @override
  void initState() {
    relationDate = duaryContext.myCouple.value!.relationDate;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XffFFFFFF),
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar(
        appBarObj: AppBar(),
        leadingBuilder: (context) => GestureDetector(
          onTap: () {
            Navigator.pop(
              context,
            );
          },
          child: const Icon(
            Icons.chevron_left,
            color: Color(0xFF9A9A9A),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 48, right: 48, bottom: 112),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 64,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "사랑이 시작된 날을 알려주세요.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0Xff464646),
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                DuaryDateInputBox(
                    initialValue: relationDate,
                    onSelect: (value) {
                      relationDate = value;
                    })
              ],
            ),
            FutureButton(
              onTap: () async {
                if (relationDate != duaryContext.myCouple.value!.relationDate) {
                  await duaryContext.updateCouple(relationDate: relationDate).then((_) {
                    Navigator.pop(context);
                  }).catchError((e) {
                    Fluttertoast.showToast(msg: e.toString());
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0XffFFBD64),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "저장하기",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0Xff573200),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
