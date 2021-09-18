import 'package:flutter/material.dart';
import 'package:urbansensor/src/utils/palettes.dart';

class Label extends StatelessWidget {
  const Label({
    Key? key,
    required this.title,
    required this.iconData,
    required this.iconColor,
    this.info,
  }) : super(key: key);
  final IconData iconData;
  final String title;
  final Color iconColor;
  final String? info;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                iconData,
                color: iconColor,
                size: 30,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Palettes.gray2,
                  ),
            ),
          ],
        ),
        Text(
          '$info',
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w500, color: Palettes.gray2, fontSize: 14),
        ),
      ],
    );
  }
}
