import 'package:flutter/material.dart';

class CustomTheme {
  static Color rose = const Color.fromRGBO(255, 131, 131, 1.0);
  static Color lightBlue = const Color.fromRGBO(92, 167, 255, 1.0);
  static Color gray1 = const Color.fromRGBO(51, 51, 51, 1.0);
  static Color gray2 = const Color.fromRGBO(79, 79, 79, 1.0);
  static Color gray3 = const Color.fromRGBO(130, 130, 130, 1.0);
  static Color gray4 = const Color.fromRGBO(189, 189, 189, 1.0);
  static Color gray5 = const Color.fromRGBO(240, 240, 240, 1.0);
  static Color gray6 = const Color.fromRGBO(246, 246, 246, 1.0);
  static Color gray7 = const Color.fromRGBO(230, 230, 230, 1.0);
  static Color athensGray = const Color.fromRGBO(245, 245, 247, 1.0);
  static Color red = const Color.fromRGBO(235, 87, 87, 1.0);
  static Color green1 = const Color.fromRGBO(33, 150, 83, 1.0);
  static Color green2 = const Color.fromRGBO(39, 174, 96, 1.0);

  static TextTheme textTheme = const TextTheme(
    headline1: TextStyle(
        fontWeight: FontWeight.w300, fontSize: 97.0, letterSpacing: -1.5),
    headline2: TextStyle(
        fontWeight: FontWeight.w300, fontSize: 61.0, letterSpacing: -0.5),
    headline3: TextStyle(
        fontWeight: FontWeight.w400, fontSize: 48.0, letterSpacing: 0),
    headline4: TextStyle(
        fontWeight: FontWeight.w400, fontSize: 34.0, letterSpacing: 0.25),
    headline5: TextStyle(
        fontWeight: FontWeight.w400, fontSize: 24.0, letterSpacing: 0),
    headline6: TextStyle(
        fontWeight: FontWeight.w500, fontSize: 20.0, letterSpacing: 0.15),
    subtitle1: TextStyle(
        fontWeight: FontWeight.w400, fontSize: 16.0, letterSpacing: 0.15),
    subtitle2: TextStyle(
        fontWeight: FontWeight.w500, fontSize: 14.0, letterSpacing: 0.1),
    bodyText1: TextStyle(
        fontWeight: FontWeight.w400, fontSize: 16.0, letterSpacing: 0.5),
    bodyText2: TextStyle(
        fontWeight: FontWeight.w400, fontSize: 14.0, letterSpacing: 0.25),
    button: TextStyle(
        fontWeight: FontWeight.w500, fontSize: 16.0, letterSpacing: 1.25),
    caption: TextStyle(
        fontWeight: FontWeight.w400, fontSize: 12.0, letterSpacing: 0.4),
    overline: TextStyle(
        fontWeight: FontWeight.w400, fontSize: 10.0, letterSpacing: 1.5),
  );
}
