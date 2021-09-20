import 'package:urbansensor/src/models/paging.dart';
import 'package:urbansensor/src/models/project.dart';

class ProjectPaginationRes {
  bool? _success;
  Paging? _paging;
  List<Project>? _content;

  bool? get success => _success;

  Paging? get paging => _paging;

  List<Project>? get content => _content;

  ProjectPaginationRes(
      {bool? success, Paging? paging, List<Project>? content}) {
    _success = success;
    _paging = paging;
    _content = content;
  }

  ProjectPaginationRes.fromJson(dynamic json) {
    _success = json['success'];
    _paging = json['paging'] != null ? Paging.fromJson(json['paging']) : null;
    if (json['content'] != null) {
      _content = [];
      json['content'].forEach((v) {
        _content?.add(Project.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['success'] = _success;
    if (_paging != null) {
      map['paging'] = _paging?.toJson();
    }
    if (_content != null) {
      map['content'] = _content?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

