import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/services/api_report.dart';
import 'package:urbansensor/src/utils/format_date.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/utils/shadow.dart';

class ReportCard extends StatefulWidget {
  const ReportCard({Key? key, required this.report}) : super(key: key);
  final Report? report;

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableScrollActionPane(),
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),
      actions: [
        _action(
            iconData: UniconsLine.trash,
            color: Palettes.rose,
            tooltip: 'Eliminar'),
        _action(
            iconData: UniconsLine.file_download_alt,
            color: Palettes.green2,
            tooltip: 'Descargar'),
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
              Navigator.pushNamed(context, 'report', arguments: widget.report!);
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
                            '${widget.report?.categories}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Palettes.gray2,
                                    ),
                          ),
                          Text(
                            '${widget.report?.address}',
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
                                  FormatDate.calendar(widget.report?.timestamp),
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
                                    FormatDate.clock(widget.report?.timestamp),
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

  Widget _action({required IconData iconData,
    required Color color,
    required String tooltip}) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: Color.fromRGBO(150, 0, 110, 0.08), blurRadius: 12)
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              if (tooltip.contains('Eliminar')) {
                await _deleteReport();
              }
            },
            child: SizedBox(
              height: double.infinity,
              child: deleting
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineScalePulseOutRapid,
                        colors: [Palettes.rose],
                      ),
                    )
                  : Icon(
                      iconData,
                      color: color,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future _deleteReport() async {
    ApiReport api = ApiReport();

    setState(() {
      deleting = true;
    });

    await api.deleteReport(reportId: '${widget.report?.id}');

    setState(() {
      deleting = false;
    });

    return true;
  }
}
