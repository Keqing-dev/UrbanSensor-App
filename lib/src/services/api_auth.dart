import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbansensor/src/models/login.dart';
import 'package:urbansensor/src/models/user.dart';
import 'package:urbansensor/src/preferences/user_preferences.dart';
import 'package:urbansensor/src/providers/user_provider.dart';
import 'package:urbansensor/src/services/api.dart';
import 'package:urbansensor/src/utils/mime_type.dart';

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

    if (response.statusCode != 200) {
      return false;
    }

    LoginResponse loginResponse =
        LoginResponse.fromJson(json.decode(response.body));

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("token", '${loginResponse.data?.token}');
    api.token = '${loginResponse.data!.token}';

    saveUser(user: loginResponse.data, context: context);

    return true;
  }

  Future getMyUser(BuildContext context) async {
    final headersTk = await Api().getHeadersTk();

    final res =
        await http.get(Uri.https(_domain, '/authenticate'), headers: headersTk);
    print('getMyUser() STATUS CODE: ${res.statusCode}');

    User? user = LoginResponse.fromJson(json.decode(res.body)).data;

    print(user?.name);
    print(user?.avatar);

    if (res.statusCode != 200) {
      return false;
    }
    saveUser(user: user, context: context);
  }

  Future uploadAvatar(
      {required BuildContext context, required File? avatarFile}) async {
    final headersTk = await Api().getHeadersTkMultiPart();

    final request = http.MultipartRequest(
        'PATCH', Uri.https(_domain, '/authenticate/avatar'));

    final file = await http.MultipartFile.fromPath(
        'file', '${avatarFile?.path}',
        contentType: getMimeType(avatarFile!.path));

    print(headersTk);

    request.files.add(file);
    request.headers.addAll(headersTk);

    final responseStream = await request.send();

    print('uploadAvatar() STATUS CODE: ${responseStream.statusCode}');

    final res = await http.Response.fromStream(responseStream);
    if (res.statusCode != 200) {
      return false;
    }

    User? user = LoginResponse.fromJson(json.decode(res.body)).data;

    saveUser(user: user, context: context);

    return true;
  }

  void saveUser({required User? user, required BuildContext context}) {
    UserPreferences userPreferences = UserPreferences();
    userPreferences.setUser = user;

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.user = user;
  }
}
