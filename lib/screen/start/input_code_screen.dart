import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/link_state_manager.dart';
import 'package:duary/screen/start/connect_copule_screen.dart';
import 'package:duary/screen/home_screen.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class InputCodeScreen extends StatefulWidget {
  const InputCodeScreen({super.key});

  @override
  State<InputCodeScreen> createState() => _InputCodeScreenState();
}

class _InputCodeScreenState extends State<InputCodeScreen> {
  late TextEditingController _controller;
  final DuaryContext duaryContext = DuaryContext();
  String coupleCode = "";

  late final LinkStateManager linkStateManager;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: coupleCode);

    linkStateManager = context.read<LinkStateManager>();
    if (linkStateManager.coupleCode.value != null) {
      _controller.text = linkStateManager.coupleCode.value!;
    }
    linkStateManager.coupleCode.addListener(codeListener);
    duaryContext.lover.addListener(onCoupleConnected);
  }

  void codeListener() {
    String? temp = linkStateManager.coupleCode.value;
    if (temp != null) {
      _controller.text = temp;
    }
  }

  void onCoupleConnected() {
    if (duaryContext.lover.value != null) {
      Navigator.pop(context);
    }
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
              MaterialPageRoute(
                  builder: (context) => const ConnectCoupleScreen()),
            );
          },
          child: const Icon(Icons.chevron_left),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 66,
              ),
              const Text(
                textAlign: TextAlign.center,
                "우리의 커플 코드를 입력해주세요.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0Xff464646),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0XffF7F7F7),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  height: 45,
                  child: TextField(
                    controller: _controller,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    ],
                    onChanged: (value) {
                      coupleCode = value;
                    },
                    cursorColor: const Color(0XffE3DDD7),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0Xff3F3F3F),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                      hintText: "코드 입력",
                      hintStyle: TextStyle(
                        color: Color(0Xff6F6F6F),
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: GestureDetector(
                  onTap: () async {
                    if (coupleCode.isEmpty == true) {
                      Fluttertoast.showToast(msg: "코드를 입력해주세요");
                    } else {
                      await duaryContext.inputCoupleCode(coupleCode).then((_) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (p) => false);
                      }).catchError((e) {
                        Fluttertoast.showToast(msg: e.toString());
                      });
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
                        "연결하기",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0Xff573200),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 144,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    duaryContext.lover.removeListener(onCoupleConnected);
    linkStateManager.coupleCode.removeListener(codeListener);
    linkStateManager.cancelSubscription();
    super.dispose();
  }
}
