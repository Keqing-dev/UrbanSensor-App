import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbansensor/src/models/login.dart';
import 'package:urbansensor/src/services/api.dart';
import 'package:http/http.dart' as http;

class ApiAuth {
  final String _domain = Api().domain;
  final _headers = Api().headers;

  Future<bool> login(String email, String password) async {
    final loginData = LoginRequest(email: email, password: password);
    final response = await http.post(
      Uri.https(_domain, "/authenticate/login"),
      headers: _headers,
      body: json.encode(loginData),
    );

    if (response.statusCode != 200) {
      return false;
    }

    LoginResponse loginResponse =
        LoginResponse.fromJson(json.decode(response.body));

    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _prefs.setString("token", loginResponse.data!.token);

    return true;
  }
}
