import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbansensor/src/models/login.dart';
import 'package:urbansensor/src/preferences/user_preferences.dart';
import 'package:urbansensor/src/providers/user_provider.dart';
import 'package:urbansensor/src/services/api.dart';
import 'package:http/http.dart' as http;

class ApiAuth {
  Api api = Api();

  final String _domain = Api().domain;
  final _headers = Api().headers;

  Future<bool> login(
      String email, String password, BuildContext context) async {
    final loginData = LoginRequest(email: email, password: password);
    final response = await http.post(
      Uri.https(_domain, "/authenticate/login"),
      headers: _headers,
      body: json.encode(loginData),
    );

    print('login() STATUS CODE: ${response.statusCode}');
    if (response.statusCode != 200) {
      return false;
    }

    LoginResponse loginResponse =
        LoginResponse.fromJson(json.decode(response.body));

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("token", '${loginResponse.data?.token}');
    api.token = '${loginResponse.data!.token}';

    UserPreferences userPreferences = UserPreferences();
    userPreferences.setUser = loginResponse.data;

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.user = loginResponse.data;

    return true;
  }
}
