import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/services/api_report.dart';
import 'package:urbansensor/src/streams/report_stream.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/widgets/maps/report_preview.dart';

class ProjectReports extends StatefulWidget {
  const ProjectReports({Key? key}) : super(key: key);

  @override
  State<ProjectReports> createState() => _ProjectReportsState();
}

class _ProjectReportsState extends State<ProjectReports> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  BitmapDescriptor? mapMarker;
  Report? _reportSelected;
  ApiReport api = ApiReport();
  ReportStream stream = ReportStream();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMarker();
  }

  @override
  Widget build(BuildContext context) {
    Project? project = ModalRoute.of(context)!.settings.arguments as Project;
    api.getReportsByProjectMap(projectId: '${project.id}');

    return Scaffold(
      appBar: AppBar(
        title: Text('${project.name}'),
        backgroundColor: Palettes.lightBlue,
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: stream.reportsProjectStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return _googleMaps(snapshot.data);
            } else if (snapshot.hasError) {
              return Icon(Icons.error_outline);
            } else {
              return Center(
                  child: Container(
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                ),
              ));
            }
          }),
    );
  }

  Widget _googleMaps(List<Report>? reports) {
    print('LONGITUDDDDD ${reports?.length}');
    double initLatitude = double.parse('${reports?[0].latitude}');
    double initLongitude = double.parse('${reports?[0].longitude}');

    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(initLatitude, initLongitude),
      zoom: 14.4746,
    );

    return Stack(
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
            _onMapCreated(controller, reports, context);
          },
          myLocationEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: true,
          onCameraMove: (position) {
            // print(position.target.longitude);
          },
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
    );
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/img/location_marker.png');
    // mapMarker = BitmapDescriptor.defaultMarker;
  }

  void _onMapCreated(GoogleMapController controller, List<Report>? reports,
      BuildContext context) {
    for (int i = 0; i < reports!.length; i++) {
      _markers.add(Marker(
        icon: mapMarker!,
        markerId: MarkerId('${reports[i].id}'),
        position: LatLng(double.parse('${reports[i].latitude}'),
            double.parse('${reports[i].longitude}')),
        onTap: () {
          setState(() {
            _reportSelected = reports[i];
          });
        },
      ));
    }
    setState(() {});
  }
}
