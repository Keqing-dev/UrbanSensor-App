import 'package:flutter/material.dart';

class TestComponents extends StatelessWidget {
  const TestComponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Text('TEXT'),
      ),

    );
  }
}
