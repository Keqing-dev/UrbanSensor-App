import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbansensor/src/models/user.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._();

  factory UserPreferences() => _instance;

  UserPreferences._();

  late SharedPreferences _preferences;

  Future initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  get getUser {
    final user = _preferences.getString('user');
    return User.fromJson(json.decode(user!));
  }

  get isLogged {
    final user = _preferences.getString('user');
    return user != null;
  }

  set setUser(User? user) {
    _preferences.setString('user', json.encode(user));
  }

  logout() {
    _preferences.remove("user");
    _preferences.remove("token");
  }

  Future clear() async {
    await _preferences.clear();
  }
}
