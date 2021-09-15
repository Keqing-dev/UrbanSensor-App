import 'package:urbansensor/src/models/user.dart';

class LoginRequest {
  LoginRequest({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
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
  User? data;
  String? message;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json["success"],
    data: User.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
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
