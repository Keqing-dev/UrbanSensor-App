import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/widgets/maps/report_preview.dart';

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
              child: ReportPreview(reportSelected: _reportSelected),
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
}
