import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urbansensor/src/pages/create_report_page.dart';

void captureImage(BuildContext context) async {
  final ImagePicker _picker = ImagePicker();
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

  // Pick an image
  // Capture a photo
  if (await Permission.camera.request().isGranted &&
      await Permission.location.request().isGranted) {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    _locationData = await location.getLocation();
    if (image != null) {
      geo.Placemark placemark = (await geo.placemarkFromCoordinates(
              _locationData.latitude!, _locationData.longitude!,
              localeIdentifier: "es_CL"))
          .first;
      print(_locationData);
      print(
          "${placemark.street}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}");
      File? imageToUpload = File.fromUri(Uri(path: image.path));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateReportPage(image: imageToUpload),
        ),
      );
    }
  }
}
