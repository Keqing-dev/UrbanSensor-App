import 'dart:io';

import 'package:flutter/material.dart';

class CreateReportPage extends StatelessWidget {
  const CreateReportPage({Key? key, required this.image}) : super(key: key);

  final File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Text('jeje'), Image.file(image)],
      ),
    );
  }
}
