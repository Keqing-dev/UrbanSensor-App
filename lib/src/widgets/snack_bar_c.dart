import 'package:flutter/material.dart';

class SnackBarC {
  static void showSnackbar(
      {required String message, required BuildContext context}) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(message),
      ),
    );
  }
}
