import 'package:http/http.dart' as http;
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/models/projects_pagination.dart';
import 'dart:convert';

import 'package:urbansensor/src/services/api.dart';
import 'package:urbansensor/src/streams/project_stream.dart';

class ApiProject {
  final String _url = Api().url;
  final String _domain = Api().domain;
  final _headersTk = Api().headersTk;

  int _page = 1;
  int _searchPage = 1;

  bool _isSearching = false;

  bool _isSearchEmpty = false;

  List<Project>? _allProjects = [];
  List<Project>? _searchedProjects = [];
  final ProjectStream _stream = ProjectStream();

  Future getLatestProject() async {
    final res =
        await http.get(Uri.parse('$_url/project/latest'), headers: _headersTk);

    print('getLatestProject() STATUS CODE: ${res.statusCode}');

    ProjectRes projectRes = ProjectRes.fromJson(json.decode(res.body));

    List<Project>? projects = projectRes.content;

    return projects;
  }

  Future getAllMyProjects() async {
    _stream.projectLoadedSink(false);

    final res = await http.get(Uri.parse('$_url/project?page=$_page'),
        headers: _headersTk);

    print('getAllMyProjects() STATUS CODE: ${res.statusCode}');

    if (res.statusCode != 200) {
      if (_page == 1) {
        _stream.projectsSink([]);
      } else {}
      _stream.projectLoadedSink(true);
      return false;
    }
    _page++;

    List<Project>? projects =
        ProjectPaginationRes.fromJson(json.decode(res.body)).content;

    _allProjects?.addAll(projects!);
    _stream.projectsSink(_allProjects);
    _stream.projectLoadedSink(true);

    return true;
  }

  Future searchMyProjects({required String name}) async {
    _isSearching = true;
    _stream.projectLoadedSink(false);

    Map<String, String> queryParameters = {
      'search': name.trim(),
      'page': _searchPage.toString()
    };
    final uri = Uri.https(_domain, '/project/search', queryParameters);

    print(uri);
    final res = await http.get(uri, headers: _headersTk);

    print('searchMyProjects() STATUS CODE: ${res.statusCode}');

    if (res.statusCode != 200) {
      if (_page == 1) {
        _stream.projectsSink([]);
      } else {}
      _isSearchEmpty = true;
      _stream.projectLoadedSink(true);
      return false;
    }
    _searchPage++;

    List<Project>? projects =
        ProjectPaginationRes.fromJson(json.decode(res.body)).content;

    _searchedProjects?.addAll(projects!);
    _stream.projectsSink(_searchedProjects);
    _stream.projectLoadedSink(true);

    return true;
  }

  Future<void> refreshAllMyProjects() async {
    cleanSearch();
    cleanProjects();
    await getAllMyProjects();
  }

  void cleanSearch() {
    _searchedProjects = [];
    _stream.projectsSink([]);
    _searchPage = 1;
    _isSearching = false;
    _isSearchEmpty = false;
  }

  void cleanProjects() {
    _page = 1;
    _allProjects = [];
    _stream.projectsSink([]);
  }

  int get searchPage => _searchPage;

  set searchPage(int value) {
    _searchPage = value;
  }

  bool get isSearchEmpty => _isSearchEmpty;

  bool get isSearching => _isSearching;
}
