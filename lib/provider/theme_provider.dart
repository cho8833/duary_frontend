import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  static final ThemeData light = ThemeData(fontFamily: 'noto-sans').copyWith(
    scaffoldBackgroundColor: Colors.white,
      textTheme: defaultTextTheme
          .copyWith(
            labelMedium: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(122, 122, 133, 1),
                fontSize: 16),
            labelSmall: const TextStyle(
                color: Color.fromRGBO(117, 117, 117, 1),
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
      checkboxTheme: checkboxThemeData);
  static final ThemeData dark = ThemeData(
          cardColor: const Color.fromRGBO(58, 68, 76, 1),
          fontFamily: 'noto-sans',
          brightness: Brightness.dark)
      .copyWith(
          textTheme: defaultTextTheme
              .apply(bodyColor: Colors.white, displayColor: Colors.white)
              .copyWith(
                labelSmall: const TextStyle(
                    color: darkSecondTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                labelMedium: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: darkSecondTextColor,
                    fontSize: 16),
              ),
          checkboxTheme: checkboxThemeData);

  static final CheckboxThemeData checkboxThemeData = CheckboxThemeData(
    side: MaterialStateBorderSide.resolveWith(
        (states) => const BorderSide(width: 1, color: Colors.blue)),
  );
  static const TextTheme defaultTextTheme = TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
    titleSmall: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 16,
    ),
    bodyMedium:
        TextStyle(fontWeight: FontWeight.w600, fontSize: 14, height: 1.428),
    labelMedium:
      TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
    labelSmall:
      TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey)
  );
  static final ThemeData _custom1 = ThemeData();

  static const Color darkSecondTextColor = Color.fromRGBO(182, 194, 207, 1);

  List<ThemeData> get themes => [light, dark, _custom1];

  ThemeData selected = light;

  void setTheme(ThemeData theme) {
    selected = theme;
    notifyListeners();
  }
}
