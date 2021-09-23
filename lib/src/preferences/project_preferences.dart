import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbansensor/src/models/project.dart';

class ProjectPreferences {
  static final ProjectPreferences _instance = ProjectPreferences._();

  factory ProjectPreferences() => _instance;

  ProjectPreferences._();

  late SharedPreferences _preferences;

  Future initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  get getProject {
    final project = _preferences.getString('project');
    return Project.fromJson(json.decode(project!));
  }

  set setProject(Project? project) {
    _preferences.setString('project', json.encode(project));
  }

  Future clear() async {
    await _preferences.clear();
  }
}
