import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/utils/palettes.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        title ?? 'Volver',
        style: TextStyle(color: Palettes.gray2, fontSize: 16),
      ),
      titleSpacing: 0,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            UniconsLine.angle_left,
            size: 40,
            color: Palettes.rose,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
