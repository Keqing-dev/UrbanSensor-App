import 'package:urbansensor/src/models/user.dart';

class ReportRes {
  bool? _success;
  List<Report>? _content;

  bool? get success => _success;
  List<Report>? get content => _content;

  ReportRes({
      bool? success, 
      List<Report>? content}){
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

  String? get id => _id;
  String? get address => _address;
  String? get file => _file;
  User? get user => _user;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get categories => _categories;
  String? get timestamp => _timestamp;

  Report({
      String? id, 
      String? address, 
      String? file, 
      User? user, 
      String? latitude, 
      String? longitude, 
      String? categories, 
      String? timestamp}){
    _id = id;
    _address = address;
    _file = file;
    _user = user;
    _latitude = latitude;
    _longitude = longitude;
    _categories = categories;
    _timestamp = timestamp;
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
    return map;
  }

}

