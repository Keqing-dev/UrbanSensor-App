import 'package:urbansensor/src/models/project.dart';

class ProjectPaginationRes {
  bool? _success;
  Paging? _paging;
  List<Project>? _content;
  int? _maxItems;

  bool? get success => _success;

  Paging? get paging => _paging;

  List<Project>? get content => _content;

  int? get maxItems => _maxItems;

  ProjectPaginationRes(
      {bool? success, Paging? paging, List<Project>? content, int? maxItems}) {
    _success = success;
    _paging = paging;
    _content = content;
    _maxItems = maxItems;
  }

  ProjectPaginationRes.fromJson(dynamic json) {
    _success = json['success'];
    _maxItems = json['maxItems'];
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

class Paging {
  String? _next;

  String? get next => _next;

  Paging({String? next}) {
    _next = next;
  }

  Paging.fromJson(dynamic json) {
    _next = json['next'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['next'] = _next;
    return map;
  }
}
