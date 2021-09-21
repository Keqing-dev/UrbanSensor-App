import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/utils/format_date.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/utils/shadow.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({Key? key, required this.report}) : super(key: key);

  final Report? report;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableScrollActionPane(),
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),
      actions: [
        _action(iconData: UniconsLine.trash, color: Palettes.rose),
        _action(
            iconData: UniconsLine.file_download_alt, color: Palettes.green2),
      ],

      child: Container(
        decoration: BoxDecoration(
          boxShadow: shadow(),
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'report', arguments: report!);
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    UniconsLine.map_marker,
                    size: 30,
                    color: Palettes.green2,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${report?.categories}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Palettes.gray2,
                                    ),
                          ),
                          Text(
                            '${report?.address}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Palettes.gray2,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  FormatDate.calendar(report?.timestamp),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Palettes.gray3,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(
                                      UniconsLine.clock,
                                      color: Palettes.rose,
                                    ),
                                  ),
                                  Text(
                                    FormatDate.clock(report?.timestamp),
                                    style: TextStyle(
                                      color: Palettes.gray3,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _action({required IconData iconData, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // color: const Color.fromRGBO(245, 245, 245, 1.0),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.12), blurRadius: 12)
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: SizedBox(
            height: double.infinity,
            child: Icon(
              iconData,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

/*

Container(
      decoration: BoxDecoration(
        boxShadow: shadow(),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, 'report', arguments: report!);
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  UniconsLine.map_marker,
                  size: 30,
                  color: Palettes.green2,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${report?.categories}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Palettes.gray2,
                                  ),
                        ),
                        Text(
                          '${report?.address}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Palettes.gray2,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                FormatDate.calendar(report?.timestamp),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Palettes.gray3,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                    UniconsLine.clock,
                                    color: Palettes.rose,
                                  ),
                                ),
                                Text(
                                  FormatDate.clock(report?.timestamp),
                                  style: TextStyle(
                                    color: Palettes.gray3,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
 */
