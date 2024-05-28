import 'package:flutter/material.dart';

mixin CheckTheme {
  bool isDarkMode() {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }
}