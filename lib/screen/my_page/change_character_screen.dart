import 'package:duary/model/enums/character.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:duary/widget/button_base.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeCharacterScreen extends StatefulWidget {
  const ChangeCharacterScreen({super.key});

  @override
  State<ChangeCharacterScreen> createState() => _ChangeCharacterScreenState();
}

class _ChangeCharacterScreenState extends State<ChangeCharacterScreen> {
  DuaryContext duaryContext = DuaryContext();

  late final Member me;

  late Character character;

  List<Character> characters = Character.values.toList();

  late int currentIndex;

  @override
  void initState() {
    me = duaryContext.me.value!;
    character = me.character!;

    characters.remove(Character.together);
    characters.remove(Character.none);

    currentIndex = characters.indexWhere((e) => e == character);

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
                  "캐릭터를 설정해주세요",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0Xff464646),
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                SizedBox(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            character = getNextCharacter(false);
                          });
                        },
                        child: const Icon(
                          Icons.chevron_left,
                          color: Color(0xFF5D5D5D),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              character = getNextCharacter(true);
                            });
                          },
                          child: Character.characterWidget(
                            character,
                            width: 80,
                          )),
                      const SizedBox(
                        width: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            character = getNextCharacter(true);
                          });
                        },
                        child: const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF5D5D5D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            FutureButton(
              onTap: () async {
                if (character != me.character) {
                  await duaryContext
                      .updateMember(character: character)
                      .then((_) {
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

  Character getNextCharacter(bool forward) {
    if (forward) {
      currentIndex += 1;
    } else {
      currentIndex -= 1;
    }
    return characters[currentIndex % characters.length];
  }
}
