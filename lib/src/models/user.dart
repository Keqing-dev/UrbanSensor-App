
class User {
  String? _id;
  String? _email;
  String? _name;
  String? _lastName;
  String? _profession;
  String? _avatar;
  Plan? _plan;
  String? _token;
  Thumbnails? _thumbnails;

  String? get id => _id;
  String? get email => _email;
  String? get name => _name;
  String? get lastName => _lastName;
  String? get profession => _profession;
  String? get avatar => _avatar;
  Plan? get plan => _plan;
  String? get token => _token;
  Thumbnails? get thumbnails => _thumbnails;

  User({
      String? id, 
      String? email, 
      String? name, 
      String? lastName, 
      String? profession, 
      String? avatar, 
      Plan? plan, 
      String? token, 
      Thumbnails? thumbnails}){
    _id = id;
    _email = email;
    _name = name;
    _lastName = lastName;
    _profession = profession;
    _avatar = avatar;
    _plan = plan;
    _token = token;
    _thumbnails = thumbnails;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _name = json['name'];
    _lastName = json['lastName'];
    _profession = json['profession'];
    _avatar = json['avatar'];
    _plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    _token = json['token'];
    _thumbnails = json['thumbnails'] != null ? Thumbnails.fromJson(json['thumbnails']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['name'] = _name;
    map['lastName'] = _lastName;
    map['profession'] = _profession;
    map['avatar'] = _avatar;
    if (_plan != null) {
      map['plan'] = _plan?.toJson();
    }
    map['token'] = _token;
    if (_thumbnails != null) {
      map['thumbnails'] = _thumbnails?.toJson();
    }
    return map;
  }

}

class Thumbnails {
  String? _xs;
  String? _sm;
  String? _md;
  String? _lg;
  String? _xl;
  String? _xxl;

  String? get xs => _xs;
  String? get sm => _sm;
  String? get md => _md;
  String? get lg => _lg;
  String? get xl => _xl;
  String? get xxl => _xxl;

  Thumbnails({
      String? xs, 
      String? sm, 
      String? md, 
      String? lg, 
      String? xl, 
      String? xxl}){
    _xs = xs;
    _sm = sm;
    _md = md;
    _lg = lg;
    _xl = xl;
    _xxl = xxl;
}

  Thumbnails.fromJson(dynamic json) {
    _xs = json['xs'];
    _sm = json['sm'];
    _md = json['md'];
    _lg = json['lg'];
    _xl = json['xl'];
    _xxl = json['xxl'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['xs'] = _xs;
    map['sm'] = _sm;
    map['md'] = _md;
    map['lg'] = _lg;
    map['xl'] = _xl;
    map['xxl'] = _xxl;
    return map;
  }

}

class Plan {
  String? _id;
  String? _name;

  String? get id => _id;
  String? get name => _name;

  Plan({
      String? id, 
      String? name}){
    _id = id;
    _name = name;
}

  Plan.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}