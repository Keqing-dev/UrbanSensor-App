import 'package:flutter/material.dart';

class TextStyleC {
  TextStyle heading1({required BuildContext context, String? fontWeight}) {
    return Theme.of(context)
        .textTheme
        .headline1!
        .copyWith(fontWeight: getFontWeight(str: fontWeight));

  }

  static TextStyle heading2(
      {required BuildContext context, String? fontWeight}) {
    return Theme.of(context)
        .textTheme
        .headline2!
        .copyWith(fontWeight: getFontWeight(str: fontWeight));

  }

  static TextStyle heading3(
      {required BuildContext context, String? fontWeight}) {
    return Theme.of(context)
        .textTheme
        .headline3!
        .copyWith(fontWeight: getFontWeight(str: fontWeight));

  }

  static TextStyle heading4(
      {required BuildContext context, String? fontWeight}) {
    return Theme.of(context)
        .textTheme
        .headline4!
        .copyWith(fontWeight: getFontWeight(str: fontWeight));

  }

  static TextStyle heading5(
      {required BuildContext context, String? fontWeight}) {
    return Theme.of(context)
        .textTheme
        .headline5!
        .copyWith(fontWeight: getFontWeight(str: fontWeight));

  }

  static TextStyle heading6(
      {required BuildContext context, String? fontWeight}) {
    return Theme.of(context)
        .textTheme
        .headline6!
        .copyWith(fontWeight: getFontWeight(str: fontWeight));

  }

  static TextStyle bodyText1(
      {required BuildContext context, String? fontWeight}) {
    return Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(fontWeight: getFontWeight(str: fontWeight));

  }

  static TextStyle bodyText2(
      {required BuildContext context, String? fontWeight}) {
    return Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(fontWeight: getFontWeight(str: fontWeight));
  }

  static FontWeight getFontWeight({required String? str}) {
    FontWeight aux;
    switch (str) {
      case 'light':
        aux = FontWeight.w300;
        break;
      case 'normal':
        aux = FontWeight.w400;
        break;
      case 'medium':
        aux = FontWeight.w500;
        break;
      case 'semi':
        aux = FontWeight.w600;
        break;
      case 'bold':
        aux = FontWeight.w700;
        break;
      default:
        aux = FontWeight.w400;
        break;
    }
    return aux;
  }
}
