class Paging {
  String? _next;
  int? _maxItems;

  String? get next => _next;

  int? get maxItems => _maxItems;

  Paging({String? next, int? maxItems}) {
    _next = next;
    _maxItems = maxItems;
  }

  Paging.fromJson(dynamic json) {
    _next = json['next'];
    _maxItems = json['maxItems'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['next'] = _next;
    map['maxItems'] = _maxItems;
    return map;
  }
}
