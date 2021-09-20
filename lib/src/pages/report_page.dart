import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/utils/format_date.dart';
import 'package:urbansensor/src/utils/loading_indicators_c.dart';
import 'package:urbansensor/src/utils/palettes.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  BitmapDescriptor? mapMarker;
  Report? _reportSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMarker();
  }

  @override
  Widget build(BuildContext context) {
    Report report = ModalRoute.of(context)!.settings.arguments as Report;
    double latitude = double.parse('${report.latitude}');
    double longitude = double.parse('${report.longitude}');

    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 16.4746,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${report.address}'),
        backgroundColor: Palettes.lightBlue,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onTap: (_) {
              setState(() {
                _reportSelected = null;
              });
            },
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _onMapCreated(controller, report, context);
            },
            myLocationEnabled: false,
            mapToolbarEnabled: false,
            minMaxZoomPreference: const MinMaxZoomPreference(14, 20),
            markers: _markers,
            zoomControlsEnabled: false,
          ),
          AnimatedPositioned(
            bottom: _reportSelected == null ? -100 : 20,
            left: 50,
            right: 50,
            duration: const Duration(milliseconds: 250),
            child: Visibility(
              visible: _reportSelected != null,
              child: _customInfoWindow(),
            ),
          )
        ],
      ),
    );
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/img/location_marker.png');
    // mapMarker = BitmapDescriptor.defaultMarker;
  }

  void _onMapCreated(
      GoogleMapController controller, Report report, BuildContext context) {
    double latitude = double.parse('${report.latitude}');
    double longitude = double.parse('${report.longitude}');
    setState(() {
      _markers.add(Marker(
        icon: mapMarker!,
        markerId: MarkerId('${report.id}'),
        position: LatLng(latitude, longitude),
        onTap: () {
          setState(() {
            _reportSelected = report;
          });
        },
      ));
    });
  }

  Widget _imageViewer(BuildContext context, Report report) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            child: Center(
              child: InteractiveViewer(
                alignPanAxis: true,
                constrained: false,
                minScale: 1,
                maxScale: 5.0,
                boundaryMargin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 2),
                child: GestureDetector(
                  onTap: () {
                    print('jeje');
                  },
                  child: CachedNetworkImage(
                    imageUrl: '${report.file}',
                    height: 300,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoViewer() {
    return AlertDialog(
      title: Text(
        'Informacion',
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
              label: '${_reportSelected?.categories}'),
          _label(
              iconData: UniconsLine.calendar_alt,
              label: '${FormatDate.calendar(_reportSelected?.timestamp)}'),
          _label(
            iconData: UniconsLine.compass,
            label:
                '${_reportSelected?.latitude}, ${_reportSelected?.longitude}',
          ),
          _label(
            iconData: UniconsLine.location_pin_alt,
            label: '${_reportSelected?.address}',
          ),
          _label(
              iconData: UniconsLine.notes,
              label: '${_reportSelected?.observations}')
        ],
      ),
      actions: [
        Material(
          color: Palettes.lightBlue,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
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

  Widget _customInfoWindow() {
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: '${_reportSelected?.file}',
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
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Palettes.lightBlue,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(
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
                                      _imageViewer(context, _reportSelected!),
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
                              ' ${_reportSelected?.categories}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Palettes.lightBlue, fontSize: 16),
                            ),
                            Text(
                              'Latitud: ${_reportSelected?.latitude}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              'Longitud: ${_reportSelected?.longitude}',
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
                          builder: (context) => _infoViewer(),
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

  Widget _label({required IconData iconData, required String label}) {
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
