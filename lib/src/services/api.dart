import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbansensor/src/models/user.dart';
import 'package:urbansensor/src/preferences/user_preferences.dart';
import 'package:urbansensor/src/services/api_auth.dart';
import 'package:urbansensor/src/services/api_project.dart';

class Api {
  static final Api _instance = Api._();

  factory Api() {
    return _instance;
  }

  Api._();

  final String url = 'https://urban.keqing.dev';
  final String domain = 'urban.keqing.dev';
  String _token = '';

  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json; charset=UTF-8',
  };

  set token(String value) {
    _token = value;
  }

  Future getHeadersTk() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String? token = _preferences.getString('token');

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future getHeadersTkMultiPart() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String? token = _preferences.getString('token');

    return {
      'Content-Type': 'multipart/form-data;',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future refreshDashboardPage(BuildContext context) async {
    User user = UserPreferences().getUser as User;
    ApiProject apiProject = ApiProject();
    ApiAuth apiAuth = ApiAuth();

    await apiProject.getLatestProject(context);
  }

  Future createFeedback(String value) async {
    final _headersTk = await Api().getHeadersTk();

    final res = await http.post(Uri.parse('$url/feedback'),
        headers: _headersTk, body: jsonEncode({"observation": value}));

    print('createFeedback() STATUS CODE: ${res.statusCode}');

    return true;
  }
}
