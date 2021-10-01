import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/place.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/preferences/project_preferences.dart';
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
  int? reportsCount;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};
  BitmapDescriptor? mapMarker;
  Report? _reportSelected;
  List<Report>? _listReportSelected;
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
          title: ListTile(
            title: Text(
              '${project.name}',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              reportsCount == null ? '' : 'Últimos $reportsCount Reportes',
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
            trailing: const Icon(
              UniconsLine.map,
              color: Colors.white,
            ),
          ),
          backgroundColor: Palettes.green2,
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
                          _listReportSelected = null;
                        });
                      },
                      mapType: MapType.normal,
                      initialCameraPosition: _initCameraPosition(reports?[0]),
                      markers: markers,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      compassEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        setState(() {
                          reportsCount = reports?.length;
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
                  // Navigator.of(context).pop();
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No posees reportes actuales'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Palettes.lightBlue,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Volver',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ));
                } else {
                  return Center(
                    child: SizedBox(
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LoadingIndicator(
                            indicatorType: Indicator.ballRotateChase,
                            colors: [
                              Palettes.gray2,
                              Colors.lightBlue,
                            ],
                          ),
                          const Text(
                            'Cargando...',
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  );
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
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 250),
              opacity: _reportSelected == null && _listReportSelected != null
                  ? 1
                  : 0,
              curve: Curves.easeIn,
              child: WillPopScope(
                onWillPop: () async {
                  bool pop = _listReportSelected == null;

                  if (!pop) {
                    setState(() {
                      _listReportSelected = null;
                    });
                    return false;
                  }

                  return pop;
                },
                child: Visibility(
                  visible:
                      _reportSelected == null && _listReportSelected != null,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Material(
                      color: const Color.fromRGBO(0, 0, 0, 0.2),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _listReportSelected = null;
                          });
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _listReportSelected?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  print('jeje2');
                                },
                                child: ReportPreview(
                                    reportSelected:
                                        _listReportSelected?[index]),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
              setState(() {
                _reportSelected = null;
                _listReportSelected =
                    Report.fromPlaceList(cluster.items.toList());
              });
            } else {
              setState(() {
                _reportSelected = Report.fromPlace(cluster.items.first);
              });
            }
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? '+${cluster.count.toString()}' : null),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    if (text == null) {
      return await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), 'assets/img/location_marker.png');
    }
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = const Color.fromRGBO(88, 217, 156, 1);
    final Paint paint2 = Paint()..color = const Color.fromRGBO(88, 217, 156, 1);
    final Paint paint3 = Paint()..color = const Color.fromRGBO(88, 217, 156, 1);
    final Paint paint4 = Paint()..color = const Color.fromRGBO(88, 217, 156, 1);

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 1, size / 1), size / 2.2, paint3);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint4);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.w500),
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
