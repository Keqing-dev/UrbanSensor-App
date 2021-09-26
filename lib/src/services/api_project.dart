import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/models/projects_pagination.dart';
import 'package:urbansensor/src/services/api.dart';
import 'package:urbansensor/src/streams/project_stream.dart';

class ApiProject {
  final String _url = Api().url;
  final String _domain = Api().domain;

  int _page = 1;
  int _searchPage = 1;

  bool _isSearching = false;

  bool _isSearchEmpty = false;

  List<Project>? _allProjects = [];
  List<Project>? _searchedProjects = [];
  final ProjectStream _stream = ProjectStream();

  Future getLatestProject(BuildContext context) async {
    final _headersTk = await Api().getHeadersTk();

    final res =
        await http.get(Uri.parse('$_url/project/latest'), headers: _headersTk);

    print('getLatestProject() STATUS CODE: ${res.statusCode}');

    if (res.statusCode != 200) {
      print('jeje');
      return Future.error('Sin proyectos');
    }

    ProjectRes projectRes = ProjectRes.fromJson(json.decode(res.body));

    List<Project>? projects = projectRes.content;

    return projects;
  }

  Future getAllMyProjects() async {
    final _headersTk = await Api().getHeadersTk();

    _stream.projectLoadedSink(false);

    final res = await http.get(Uri.parse('$_url/project?page=$_page'),
        headers: _headersTk);

    print('getAllMyProjects() STATUS CODE: ${res.statusCode}');
    print('getAllMyProjects() PAGE ${_page}');

    if (res.statusCode != 200) {
      if (_page == 1) {
        _stream.projectsSink([]);
      } else {}
      _stream.projectLoadedSink(true);
      return false;
    }
    _page++;

    ProjectPaginationRes? projectRes =
        ProjectPaginationRes.fromJson(json.decode(res.body));

    List<Project>? projects = projectRes.content;
    _stream.maxItemsSink(projectRes.paging?.maxItems);

    _allProjects?.addAll(projects!);
    _stream.projectsSink(_allProjects);
    _stream.projectLoadedSink(true);

    return true;
  }

  Future<List<Project>?> getProjectsList() async {
    final _headersTk = await Api().getHeadersTk();
    final res = await http.get(Uri.parse('$_url/project?page=$_page'),
        headers: _headersTk);

    if (res.statusCode != 200) {
      return null;
    }

    ProjectPaginationRes? projectRes =
        ProjectPaginationRes.fromJson(json.decode(res.body));

    return projectRes.content;
  }

  Future searchMyProjects({required String name}) async {
    final _headersTk = await Api().getHeadersTk();
    _isSearching = true;
    _stream.projectLoadedSink(false);

    Map<String, String> queryParameters = {
      'search': name.trim(),
      'page': _searchPage.toString()
    };
    final uri = Uri.https(_domain, '/project/search', queryParameters);

    final res = await http.get(uri, headers: _headersTk);

    print('searchMyProjects() STATUS CODE: ${res.statusCode}');

    print(_searchPage);
    if (res.statusCode != 200) {
      if (_searchPage == 1) {
        _stream.projectsSink([]);
      } else {}
      _stream.maxItemsSink(0);
      _isSearchEmpty = true;
      _stream.projectLoadedSink(true);
      return false;
    }

    if (_searchPage == 1) {
      _searchedProjects = [];
      _stream.projectsSink([]);
    }
    _searchPage++;

    ProjectPaginationRes? projectRes =
        ProjectPaginationRes.fromJson(json.decode(res.body));

    List<Project>? projects = projectRes.content;

    _stream.maxItemsSink(projectRes.paging?.maxItems);
    _searchedProjects?.addAll(projects!);
    _stream.projectsSink(_searchedProjects);
    _stream.projectLoadedSink(true);

    return true;
  }

  Future createProject(
      {required String name, required BuildContext context}) async {
    final _headersTk = await Api().getHeadersTk();

    final res = await http.post(Uri.parse('$_url/project'),
        headers: _headersTk, body: jsonEncode({"name": name}));

    print('createProject() STATUS CODE: ${res.statusCode}');

    if (res.statusCode != 200) {
      return false;
    }

    Project? project = ProjectRes.fromJson(json.decode(res.body)).data;

    return project;
  }

  Future modifyProject(
      {required String projectId, required String title}) async {
    final _headersTk = await Api().getHeadersTk();

    final res = await http.patch(Uri.parse('$_url/project'),
        headers: _headersTk,
        body: jsonEncode({"name": title, "id": projectId}));

    print('modifyProject() STATUS CODE: ${res.statusCode}');

    if (res.statusCode != 200) {
      return false;
    }

    Project? project = ProjectRes.fromJson(json.decode(res.body)).data;

    return project;
  }

  Future downloadReports({required String projectId}) async {
    final _headersTk = await Api().getHeadersTk();

    Map<String, String> queryParameters = {
      'projectId': projectId.trim(),
      'page': '1'
    };
    final uri = Uri.https(_domain, '/csv/reports', queryParameters);

    if (await Permission.storage.request().isGranted) {
      final res = await http.get(uri, headers: _headersTk);

      print('downloadCsv() STATUS CODE: ${res.statusCode}');

      if (res.statusCode != 200) {
        return false;
      }

      final baseStorage = await getExternalStorageDirectory();
      final taskId = await FlutterDownloader.enqueue(
        url: uri.toString(),
        headers: _headersTk,
        savedDir: baseStorage!.path,
        showNotification: true,
        openFileFromNotification: true,
      );
      return true;
    }

    return false;
  }

  Future deleteProject({required String projectId}) async {
    final _headersTk = await Api().getHeadersTk();

    final res = await http.delete(
        Uri.parse('$_url/project?projectId=$projectId'),
        headers: _headersTk);

    print('deleteProject() STATUS CODE: ${res.statusCode}');

    if (res.statusCode != 200) {
      return false;
    }

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

  int get page => _page;
}
