class RegisterRequest {
  RegisterRequest({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
