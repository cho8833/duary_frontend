import 'dart:async';

import 'package:flutter/cupertino.dart';

class TimeManager extends ChangeNotifier {
  late DateTime _now;

  late Timer timer;

  TimeManager() {
    _now = DateTime.now();
    timer = Timer.periodic(const Duration(minutes: 1), (time) {
      _now = DateTime.now();
      notifyListeners();
    });
  }

  DateTime get now => _now;
}