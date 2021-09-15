class Login {
  Login({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };
}

class LoginResponse {
  LoginResponse({
    required this.success,
    this.data,
    this.message,
  });

  bool success;
  Data? data;
  String? message;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  Data({
    required this.id,
    required this.email,
    required this.name,
    required this.lastName,
    required this.profession,
    required this.plan,
    required this.token,
  });

  String id;
  String email;
  String name;
  String lastName;
  String profession;
  Plan plan;
  String token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    lastName: json["lastName"],
    profession: json["profession"],
    plan: Plan.fromJson(json["plan"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "lastName": lastName,
    "profession": profession,
    "plan": plan.toJson(),
    "token": token,
  };
}

class Plan {
  Plan({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
