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
import 'package:urbansensor/src/utils/format_date.dart';
import 'package:urbansensor/src/utils/theme.dart';
import 'package:urbansensor/src/widgets/navigators/back_app_bar.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  File? _image;
  String? _dateTime;
  LatLng? _latLng;
  String? _address;
  late CameraPosition _kGooglePlex;
  Set<Marker> _markers = {};
  BitmapDescriptor? mapMarker;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    // _compressImage();
    _setCustomMarker();
    _captureData();
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
                      SizedBox(
                        width: double.infinity,
                        height: 164,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        height: 164,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: CustomTheme.gray3),
                        ),
                        child: ClipRRect(
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
                            onTap: (_) {
                              _showGeneralDialog();
                            },
                          ),
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
          child: Container(
            child: Text(
              content,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  void _setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/img/location_marker.png');
    // mapMarker = BitmapDescriptor.defaultMarker;
  }

  void _showGeneralDialog() {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return StatefulBuilder(builder: (context, setStateSecondary) {
            return Scaffold(
              body: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: _markers,
                onTap: (latLng) {
                  setStateSecondary(() {
                    setState(() {
                      _updatePosition(latLng);
                    });
                  });
                },
              ),
            );
          });
        });
  }

  void _updatePosition(LatLng latLng) async {
    geo.Placemark placemark = (await geo.placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
      localeIdentifier: "es_CL",
    ))
        .first;
    _latLng = latLng;
    _address =
        "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}";
    _markers = {};
    _latLng = latLng;
    _markers.add(Marker(
      icon: mapMarker!,
      markerId: MarkerId(latLng.toString()),
      position: latLng,
    ));
    _moveCamera(latLng);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _moveCamera(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15.8)));
  }

  void _captureData() async {
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
            markerId: MarkerId('Yoshida'),
            position: LatLng(_location.latitude!, _location.longitude!),
          ));
        });
      } else {
        Navigator.of(context).pop();
      }
    }
  }
}
