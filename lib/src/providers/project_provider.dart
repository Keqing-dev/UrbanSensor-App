import 'package:flutter/material.dart';
import 'package:urbansensor/src/models/project.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project>? _projects;

  List<Project>? get projects => _projects;

  set setProjects(List<Project>? value) {
    _projects = value!;
    notifyListeners();
  }
}
