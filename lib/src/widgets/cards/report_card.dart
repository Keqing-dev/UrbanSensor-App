import 'package:flutter/material.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/utils/format_date.dart';
import 'package:urbansensor/src/utils/palettes.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({Key? key, required this.report}) : super(key: key);

  final Report? report;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.place,
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
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
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
                                  Icons.schedule,
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
    );
  }
}
