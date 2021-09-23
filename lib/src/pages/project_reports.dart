import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/preferences/project_preferences.dart';
import 'package:urbansensor/src/services/api_report.dart';
import 'package:urbansensor/src/streams/report_stream.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/utils/place.dart';
import 'package:urbansensor/src/widgets/maps/report_preview.dart';

class ProjectReports extends StatefulWidget {
  const ProjectReports({Key? key}) : super(key: key);

  @override
  State<ProjectReports> createState() => _ProjectReportsState();
}

class _ProjectReportsState extends State<ProjectReports> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
  BitmapDescriptor? mapMarker;
  Report? _reportSelected;
  ApiReport api = ApiReport();
  ReportStream stream = ReportStream();
  ProjectPreferences preferences = ProjectPreferences();

  //Clustering
  late ClusterManager _manager;

  @override
  void initState() {
    super.initState();
    Project project = ProjectPreferences().getProject as Project;
    api.getReportsByProjectMap(projectId: '${project.id}');
    _manager = _initClusterManager();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(
      [],
      _updateMarkers,
      markerBuilder: _markerBuilder,
    );
  }

  CameraPosition _initCameraPosition(Report? report) {
    return CameraPosition(
        target: LatLng(double.parse('${report?.latitude}'),
            double.parse('${report?.longitude}')),
        zoom: 12.0);
  }

  ClusterManager _apiClusterManager(List<Report>? reports) {
    List<Place>? places = Report.toPlace(reports!);
    return ClusterManager<Place>(
      places!,
      _updateMarkers,
      markerBuilder: _markerBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    Project? project = ModalRoute.of(context)!.settings.arguments as Project;

    return Scaffold(
        appBar: AppBar(
          title: Text('${project.name}'),
          backgroundColor: Palettes.lightBlue,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            StreamBuilder(
              stream: stream.reportsProjectMapStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<Report>? reports = snapshot.data;
                  return GoogleMap(
                      onTap: (_) {
                        setState(() {
                          _reportSelected = null;
                        });
                      },
                      mapType: MapType.normal,
                      initialCameraPosition: _initCameraPosition(reports?[0]),
                      markers: markers,
                      onMapCreated: (GoogleMapController controller) {
                        setState(() {
                          _manager = _apiClusterManager(reports);
                        });

                        _controller.complete(controller);

                        setState(() {
                          _manager.setMapId(controller.mapId);
                        });
                      },
                      onCameraMove: _manager.onCameraMove,
                      onCameraIdle: _manager.updateMap);
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  return CircularProgressIndicator();
                }
              },
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
        ));
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');

            if (cluster.items.length != 1) {
              cluster.items.forEach((p) => {});
            } else {
              setState(() {
                _reportSelected = Report(id: cluster.items.first.name);
              });
            }
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? '+${cluster.count.toString()}' : null),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Palettes.green2;
    final Paint paint2 = Paint()..color = Color.fromRGBO(62, 57, 53, 1);
    final Paint paint3 = Paint()..color = Color.fromRGBO(62, 57, 53, 1);

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 1, size / 1), size / 2.2, paint3);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
