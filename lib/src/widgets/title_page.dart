import 'package:flutter/material.dart';
import 'package:urbansensor/src/utils/palettes.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({
    Key? key,
    required this.title,
    this.caption,
    this.iconData,
    this.iconFunc,
  }) : super(key: key);

  final String title;
  final String? caption;
  final IconData? iconData;
  final Function? iconFunc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w500, color: Palettes.gray1),
              ),
              Text(
                '$caption',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Palettes.gray3),
              ),
            ],
          ),
        ),
        InkWell(
            onTap: () {
              if (iconFunc != null) {
                iconFunc!();
              }
            },
            child: Icon(iconData, size: 35, color: Palettes.lightBlue)),
      ],
    );
  }
}
