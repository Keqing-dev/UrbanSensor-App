import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/pages/video_viewer.dart';
import 'package:urbansensor/src/services/api_project.dart';
import 'package:urbansensor/src/services/api_report.dart';
import 'package:urbansensor/src/streams/project_stream.dart';
import 'package:urbansensor/src/utils/format_date.dart';
import 'package:urbansensor/src/utils/theme.dart';
import 'package:urbansensor/src/widgets/file_type.dart';
import 'package:urbansensor/src/widgets/navigators/back_app_bar.dart';
import 'package:urbansensor/src/widgets/snack_bar_c.dart';
import 'package:video_player/video_player.dart';

import 'image_viewer.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({
    Key? key,
    required this.fileType,
  }) : super(key: key);

  final FileType fileType;

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  File? _image;
  File? _video;
  String? _dateTime;
  LatLng? _latLng;
  String? _address;
  late CameraPosition _kGooglePlex;
  Set<Marker> _markers = {};
  BitmapDescriptor? mapMarker;
  final Completer<GoogleMapController> _controller = Completer();
  final Completer<GoogleMapController> _fullMapController = Completer();
  final _transformationController = TransformationController();
  late TapDownDetails _doubleTapDetails;
  final ApiProject _apiProject = ApiProject();
  final ApiReport _apiReport = ApiReport();
  ProjectStream stream = ProjectStream();
  List<Project>? projectList;
  String? dropdownValue;

  bool isVideo = false;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    // _compressImage();
    _apiProject.getAllMyProjects();
    _setCustomMarker();
    switch (widget.fileType) {
      case FileType.photo:
        _capturePhoto();
        break;
      case FileType.video:
        _captureVideo();
        break;
      case FileType.mic:
        break;
      default:
        _capturePhoto();
        break;
    }
  }

  @override
  void dispose() {
    _image?.delete();
    _video?.delete();
    _video = null;
    _image = null;
    _videoController.dispose();
    print('DISPOSE');

    super.dispose();
  }

  // _compressImage() async {
  //   var filePath = widget.image.absolute.path;
  //
  //   final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
  //   final splitted = filePath.substring(0, (lastIndex));
  //   final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
  //
  //   FlutterImageCompress.compressAndGetFile(widget.image.path, outPath,
  //           quality: 80 /*, minHeight: height, minWidth: width*/)
  //       .then((newImage) {
  //     setState(() {
  //       compressedImage = newImage;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const BackAppBar(),
      body: Builder(builder: (context) {
        return SafeArea(
          child: _image == null &&
                  _video == null &&
                  _dateTime == null &&
                  _latLng == null &&
                  _address == null
              ? Center(
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballClipRotateMultiple,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 42.0),
                  child: Column(
                    children: [
                      Text(
                        'Crear Reporte',
                        style: theme.textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      _reportData(
                        icon: UniconsLine.calendar_alt,
                        content: _dateTime!,
                      ),
                      const SizedBox(height: 12.0),
                      _reportData(
                        icon: UniconsLine.compass,
                        content: "${_latLng!.latitude}, ${_latLng!.longitude}",
                      ),
                      const SizedBox(height: 12.0),
                      _reportData(
                        icon: UniconsLine.location_pin_alt,
                        content: _address!,
                      ),
                      const SizedBox(height: 16.0),
                      _video != null ? _videoPreview() : _imagePreview(),
                      const SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        height: 164,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: CustomTheme.gray3),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: _kGooglePlex,
                                markers: _markers,
                                zoomControlsEnabled: false,
                                zoomGesturesEnabled: false,
                                tiltGesturesEnabled: false,
                                scrollGesturesEnabled: false,
                                rotateGesturesEnabled: false,
                                mapToolbarEnabled: false,
                                onCameraMove: null,
                                onMapCreated: _onMapCreated,
                                myLocationEnabled: false,
                                myLocationButtonEnabled: false,
                              ),
                            ),
                            SizedBox.expand(
                              child: GestureDetector(
                                onTap: _showMap,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }

  Widget _reportData({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 24.0),
        Flexible(
          child: Text(
            content,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/img/location_marker.png');
  }

  Widget _imagePreview() {
    return SizedBox(
      width: double.infinity,
      height: 164,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: GestureDetector(
          onTap: () {
            showGeneralDialog(
                context: context,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ImageViewer(image: _image!);
                });
          },
          child: Image.file(
            _image!,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  Widget _videoPreview() {
    return Stack(
      children: [
        SizedBox(
          height: 164,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: GestureDetector(
              onTap: () {
                showGeneralDialog(
                    context: context,
                    pageBuilder: (_, __, ___) => VideoViewer(file: _video!));
              },
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              // padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                // color: Colors.redAccent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: FloatingActionButton(
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.75),
                onPressed: () {
                  showGeneralDialog(
                      context: context,
                      pageBuilder: (_, __, ___) => VideoViewer(file: _video!));
                },
                child: const Icon(UniconsLine.play),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showMap() {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return StatefulBuilder(builder: (context, setStateSecondary) {
            return Scaffold(
              body: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: _markers,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onMapCreated: _onFullMapCreated,
                onTap: (latLng) {
                  setStateSecondary(() {
                    setState(() {
                      _updatePosition(latLng);
                    });
                  });
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(UniconsLine.crosshairs),
                onPressed: () {
                  _setCurrentPosition(setStateSecondary);
                },
              ),
            );
          });
        });
  }

  void _setCurrentPosition(
      void Function(void Function()) setStateSecondary) async {
    Location location = Location();

    bool _serviceEnabled;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    if (await Permission.location.request().isGranted) {
      _locationData = await location.getLocation();
      print(_locationData);
      setStateSecondary(() {
        setState(() {
          LatLng latLng =
              LatLng(_locationData.latitude!, _locationData.longitude!);
          _updatePosition(latLng);
        });
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _updatePosition(LatLng latLng) async {
    print(latLng);
    geo.Placemark placemark = (await geo.placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
      localeIdentifier: "es_CL",
    ))
        .first;

    _latLng = latLng;
    _address =
        "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}";
    _kGooglePlex = CameraPosition(
      target: latLng,
      zoom: 15.8,
    );
    _markers = {};
    _latLng = latLng;
    _markers.add(Marker(
      icon: mapMarker!,
      markerId: MarkerId(latLng.toString()),
      position: latLng,
    ));
    _moveCamera(latLng);
    _animateCamera(latLng);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _moveCamera(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15.8)));
  }

  void _onFullMapCreated(GoogleMapController controller) {
    _fullMapController.complete(controller);
  }

  void _animateCamera(LatLng latLng) async {
    final GoogleMapController controller = await _fullMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15.8)));
  }

  void _capturePhoto() async {
    final ImagePicker _picker = ImagePicker();
    Location location = Location();

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    if (await Permission.camera.request().isGranted &&
        await Permission.location.request().isGranted) {
      final XFile? picture =
          await _picker.pickImage(source: ImageSource.camera);
      LocationData _location = await location.getLocation();

      if (picture != null) {
        geo.Placemark placemark = (await geo.placemarkFromCoordinates(
          _location.latitude!,
          _location.longitude!,
          localeIdentifier: "es_CL",
        ))
            .first;

        File? imageToCompress = File.fromUri(Uri(path: picture.path));

        _apiProject.getAllMyProjects();

        setState(() {
          _image = imageToCompress;
          _dateTime = FormatDate.dateTime(DateTime.now());
          _latLng = LatLng(_location.latitude!, _location.longitude!);
          _address =
              "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}";
          _kGooglePlex = CameraPosition(
            target: LatLng(_location.latitude!, _location.longitude!),
            zoom: 15.8,
          );
          _markers.add(Marker(
            icon: mapMarker!,
            markerId: MarkerId(_location.toString()),
            position: LatLng(_location.latitude!, _location.longitude!),
          ));
        });
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  void _captureVideo() async {
    print('VIDEOOO');
    final ImagePicker _picker = ImagePicker();
    Location location = Location();
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    if (await Permission.camera.request().isGranted) {
      // Capture a video
      final XFile? video = await _picker.pickVideo(
          source: ImageSource.camera, maxDuration: const Duration(seconds: 10));
      if (video == null) {
        Navigator.of(context).pop();
      }

      File? videoPreview = File.fromUri(Uri(path: video?.path));
      LocationData _location = await location.getLocation();

      geo.Placemark placemark = (await geo.placemarkFromCoordinates(
        _location.latitude!,
        _location.longitude!,
        localeIdentifier: "es_CL",
      ))
          .first;

      setState(() {
        _video = videoPreview;
        isVideo = true;
        _dateTime = FormatDate.dateTime(DateTime.now());
        _latLng = LatLng(_location.latitude!, _location.longitude!);
        _address =
            "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}";
        _kGooglePlex = CameraPosition(
          target: LatLng(_location.latitude!, _location.longitude!),
          zoom: 15.8,
        );
        _markers.add(Marker(
          icon: mapMarker!,
          markerId: MarkerId('Yoshida'),
          position: LatLng(_location.latitude!, _location.longitude!),
        ));
      });

      _videoController = VideoPlayerController.network(_video!.path)
        ..initialize().then((_) {
          setState(() {}); //when your thumbnail will show.
        });
    } else {
      Navigator.of(context).pop();
      SnackBarC.showSnackbar(
          message: 'Debes aceptar los permisos', context: context);
    }
  }
}
