import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:urbansensor/src/models/plan.dart';
import 'package:urbansensor/src/models/register.dart';

import 'api.dart';

class ApiRegister {
  Api api = Api();

  final String _domain = Api().domain;
  final _headers = Api().headers;

  Future<List<Plan>?> getPlans() async {
    final response = await http.get(
      Uri.https(_domain, "/plan"),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      return null;
    }

    PlanResponse planResponse =
        PlanResponse.fromJson(json.decode(response.body));

    return planResponse.data;
  }

  Future<int> register(String email, String password, String name,
      String lastName, String profession, String planId) async {
    final registerData = RegisterRequest(
      email: email,
      password: password,
      name: name,
      lastName: lastName,
      profession: profession,
      planId: planId,
    );
    final response = await http.post(
      Uri.https(_domain, "/authenticate/register"),
      headers: _headers,
      body: json.encode(registerData),
    );

    return response.statusCode;
  }
}
