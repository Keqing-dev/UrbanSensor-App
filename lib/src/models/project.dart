class ProjectRes {
  bool? _success;
  List<Project>? _content;
  Project? _data;

  bool? get success => _success;

  List<Project>? get content => _content;

  ProjectRes({bool? success, List<Project>? content, Project? data}) {
    _success = success;
    _content = content;
    _data = data;
  }

  ProjectRes.fromJson(dynamic json) {
    _success = json['success'];
    if (json['content'] != null) {
      _content = [];
      json['content'].forEach((v) {
        _content?.add(Project.fromJson(v));
      });
    }
    if (json['data'] != null) {
      _data = Project.fromJson(json['data']);
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

  Project? get data => _data;
}

class Project {
  String? _id;
  String? _name;
  String? _createdAt;
  String? _reportsCount;

  String? get id => _id;

  String? get name => _name;

  String? get createdAt => _createdAt;

  String? get reportsCount => _reportsCount;

  Project({String? id, String? name, String? createdAt, String? reportsCount}) {
    _id = id;
    _name = name;
    _createdAt = createdAt;
    _reportsCount = reportsCount;
  }

  Project.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _createdAt = json['createdAt'];
    _reportsCount = json['reportsCount'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['createdAt'] = _createdAt;
    map['reportsCount'] = _reportsCount;
    return map;
  }
}
