/// success : true
/// data : [{"id":"1","name":"Empresa"}]

class PlanResponse {
  PlanResponse({
    bool? success,
    List<Plan>? data,
  }) {
    _success = success;
    _data = data;
  }

  PlanResponse.fromJson(dynamic json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Plan.fromJson(v));
      });
    }
  }

  bool? _success;
  List<Plan>? _data;

  bool? get success => _success;

  List<Plan>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "1"
/// name : "Empresa"

class Plan {
  Plan({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Plan.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  String? _id;
  String? _name;

  String? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}
