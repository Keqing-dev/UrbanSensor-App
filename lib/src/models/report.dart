
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbansensor/src/models/place.dart';
import 'package:urbansensor/src/models/user.dart';

class ReportRes {
  bool? _success;
  List<Report>? _content;

  bool? get success => _success;

  List<Report>? get content => _content;

  ReportRes({bool? success, List<Report>? content}) {
    _success = success;
    _content = content;
  }

  ReportRes.fromJson(dynamic json) {
    _success = json['success'];
    if (json['content'] != null) {
      _content = [];
      json['content'].forEach((v) {
        _content?.add(Report.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['success'] = _success;
    if (_content != null) {
      map['content'] = _content?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Report {
  String? _id;
  String? _address;
  String? _file;
  User? _user;
  String? _latitude;
  String? _longitude;
  String? _categories;
  String? _timestamp;
  String? _observations;

  String? get id => _id;

  String? get address => _address;

  String? get file => _file;

  User? get user => _user;

  String? get latitude => _latitude;

  String? get longitude => _longitude;

  String? get categories => _categories;

  String? get timestamp => _timestamp;

  String? get observations => _observations;


  Report({
    String? id,
    String? address,
    String? file,
    User? user,
    String? latitude,
    String? longitude,
    String? categories,
    String? timestamp,
    String? observations,
  }) {
    _id = id;
    _address = address;
    _file = file;
    _user = user;
    _latitude = latitude;
    _longitude = longitude;
    _categories = categories;
    _timestamp = timestamp;
    _observations = observations;
  }

  Report.fromJson(dynamic json) {
    _id = json['id'];
    _address = json['address'];
    _file = json['file'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _categories = json['categories'];
    _timestamp = json['timestamp'];
    _observations = json['observations'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['address'] = _address;
    map['file'] = _file;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['categories'] = _categories;
    map['timestamp'] = _timestamp;
    map['observations'] = _observations;
    return map;
  }

  static List<Place>? toPlace(List<Report> reports) {
    List<Place>? places = [];
    for (int i = 0; i < reports.length; i++) {
      places.add(Place(
        id: '${reports[i].id}',
        latLng: LatLng(
            double.parse('${reports[i].latitude}'),
            double.parse(
              '${reports[i].longitude}',
            )),
        categories: '${reports[i].categories}',
        observations: reports[i].observations,
        file: '${reports[i].file}',
        timestamp: '${reports[i].timestamp}',
        address: '${reports[i].address}',
      ));
    }
    return places;
  }

  Report.fromPlace(Place place) {
    _id = place.id;
    _address = place.address;
    _file = place.file;
    _latitude = '${place.latLng.latitude}';
    _longitude = '${place.latLng.longitude}';
    _categories = place.categories;
    _timestamp = place.timestamp;
    _observations = place.observations;
  }

  static List<Report>? fromPlaceList(List<Place> places) {
    List<Report>? reports = [];
    for (Place place in places) {
      reports.add(Report.fromPlace(place));
    }

    return reports;
  }
}
