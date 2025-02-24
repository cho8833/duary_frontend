import 'package:duary/widget/main_app_bar.dart';
import 'package:flutter/material.dart';

class InputCoupleInfoScreen extends StatefulWidget {
  const InputCoupleInfoScreen({super.key});

  @override
  State<InputCoupleInfoScreen> createState() => _InputCoupleInfoScreenState();
}

class _InputCoupleInfoScreenState extends State<InputCoupleInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(appBarObj: AppBar()),
      body: const Column(
        children: [
          SizedBox(height: 58,),
          Text("만나서 반가워요!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),)
        ],
      ),
    );
  }
}
