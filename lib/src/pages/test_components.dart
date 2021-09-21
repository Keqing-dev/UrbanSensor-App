import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TestComponents extends StatelessWidget {
  const TestComponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Slidable(
                // Specify a key if the Slidable is dismissible.
                key: const ValueKey(0),
                actions: [
                  IconSlideAction(
                    caption: 'caption',
                    icon: Icons.dashboard,
                    onTap: () {
                      print('jeje');
                    },
                  ),
                ],
                actionPane: SlidableScrollActionPane(),
                actionExtentRatio: 1 / 4,
                child: ListTile(title: Text('Slide me')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
