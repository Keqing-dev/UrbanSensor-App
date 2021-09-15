import 'package:flutter/material.dart';
import 'package:urbansensor/src/utils/shadow.dart';

class Button extends StatelessWidget {
  final Widget content;
  final Color fillColor;
  final Color textColor;
  final ButtonType? type;
  final VoidCallback? onPressed;

  const Button({Key? key,
    required this.content,
    this.fillColor = const Color.fromRGBO(255, 131, 131, 1),
    this.textColor = Colors.white, this.type, required this.onPressed,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button;
    List<BoxShadow> boxShadow = [];
    switch (type) {
      case ButtonType.text:
        button = TextButton(
          child: content,
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0,
            primary: fillColor,
          ),
        );
        break;
      case ButtonType.elevated:
      default:
        button = ElevatedButton(
          child: content,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0,
            primary: fillColor,
            onPrimary: textColor,
          ),
        );
        boxShadow = shadow();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: boxShadow,
      ),
      child: button,
    );
  }
}

enum ButtonType {
  elevated,
  text
}
