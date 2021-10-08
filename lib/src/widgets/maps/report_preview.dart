import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/pages/image_viewer.dart';
import 'package:urbansensor/src/pages/video_viewer.dart';
import 'package:urbansensor/src/utils/format_date.dart';
import 'package:urbansensor/src/utils/general_util.dart';
import 'package:urbansensor/src/utils/loading_indicators_c.dart';
import 'package:urbansensor/src/utils/palettes.dart';

class ReportPreview extends StatelessWidget {
  const ReportPreview({Key? key, required this.reportSelected})
      : super(key: key);

  final Report? reportSelected;

  @override
  Widget build(BuildContext context) {
    bool isVideo = GeneralUtil.isVideoFormat('${reportSelected?.file}');
    bool isAudio = GeneralUtil.isAudioFormat('${reportSelected?.file}');
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(173, 173, 173, 0.25),
            blurRadius: 12.0,
          )
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Stack(
                      children: [
                        isVideo
                            ? Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Palettes.lightBlue,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  UniconsLine.play,
                                  color: Palettes.lightBlue,
                                ),
                              )
                            : isAudio
                                ? Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Palettes.lightBlue,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      UniconsLine.microphone,
                                      color: Palettes.lightBlue,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: '${reportSelected?.file}',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                      placeholder: (context, url) =>
                                          LoadingIndicatorsC.ballScale,
                                      errorWidget: (_, _1, _2) => Icon(
                                        UniconsLine.image_broken,
                                        color: Palettes.rose,
                                      ),
                                    ),
                                  ),
                        isVideo
                            ? Container()
                            : isAudio
                                ? Container()
                                : Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Palettes.lightBlue,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: const Icon(
                                        UniconsLine.search_plus,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                showGeneralDialog(
                                  context: context,
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      isVideo || isAudio
                                          ? VideoViewer(
                                              file: File('null'),
                                              url: reportSelected?.file,
                                            )
                                          : ImageViewer(
                                              url: reportSelected?.file,
                                            ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' ${reportSelected?.categories}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Palettes.lightBlue, fontSize: 16),
                            ),
                            Text(
                              'Latitud: ${reportSelected?.latitude}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              'Longitud: ${reportSelected?.longitude}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => _infoViewer(context),
                        );
                      },
                      child: Icon(
                        UniconsLine.expand_arrows_alt,
                        size: 30,
                        color: Palettes.lightBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoViewer(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Información',
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.w600,
              color: Palettes.gray2,
            ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _label(
              iconData: UniconsLine.tag_alt,
              context: context,
              label: '${reportSelected?.categories}'),
          _label(
            iconData: UniconsLine.calendar_alt,
            label: FormatDate.calendar(reportSelected?.timestamp),
            context: context,
          ),
          _label(
            iconData: UniconsLine.compass,
            context: context,
            label: '${reportSelected?.latitude}, ${reportSelected?.longitude}',
          ),
          _label(
            iconData: UniconsLine.location_pin_alt,
            context: context,
            label: '${reportSelected?.address}',
          ),
          _label(
              iconData: UniconsLine.notes,
              context: context,
              label: reportSelected?.observations ?? 'Sin observaciones')
        ],
      ),
      actions: [
        Material(
          color: Palettes.lightBlue,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Cerrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(
      {required IconData iconData,
      required String label,
      required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          color: Palettes.lightBlue,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: Palettes.gray2,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
