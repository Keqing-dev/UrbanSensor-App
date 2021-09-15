import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:urbansensor/src/models/login.dart';

class AuthProvider {
  String baseUrl = "urban.keqing.dev";

  Future<String> login(String? email, String? password) async {
    final Login loginData =
        Login(email: "AzuKI@keqing.dev", password: "Yoshida2021");

    Response response = await post(
      Uri.https(baseUrl, "/authenticate/login"),
      body: json.encode(loginData.toJson()),
      headers: {"Content-Type": "application/json"},
    );

    LoginResponse xd = LoginResponse.fromJson(json.decode(response.body));

    // if(response.statusCode != 200)
    //   return xd.message.isEmpty ?? response.reasonPhrase;


    print("aa ${xd.data?.token}");
    print("bb ${xd.message}");
  }
}
