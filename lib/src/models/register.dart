class RegisterRequest {
  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.lastName,
    required this.profession,
    required this.planId,
  });

  String email;
  String password;
  String name;
  String lastName;
  String profession;
  String planId;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        email: json["email"],
        password: json["password"],
        name: json["name"],
        lastName: json["lastName"],
        profession: json["profession"],
        planId: json["planId"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "lastName": lastName,
        "profession": profession,
        "planId": planId,
      };
}
