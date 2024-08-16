import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: Colors.white,
      fontFamily: 'NanumSquareRound');
  static final ThemeData dark =
      ThemeData(fontFamily: 'NanumSquareRound', brightness: Brightness.dark);

  // .apply(bodyColor: Colors.white, displayColor: Colors.white)
  // .copyWith(
  //   labelSmall: const TextStyle(
  //       color: darkSecondTextColor,
  //       fontSize: 14,
  //       fontWeight: FontWeight.w500),
  //   labelMedium: const TextStyle(
  //       fontWeight: FontWeight.w400,
  //       color: darkSecondTextColor,
  //       fontSize: 16),

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
      labelMedium: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
      labelSmall: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey));
  static final ThemeData _custom1 = ThemeData();

  List<ThemeData> get themes => [light, dark, _custom1];

  ThemeData selected = light;

  void setTheme(ThemeData theme) {
    selected = theme;
    notifyListeners();
  }
}
