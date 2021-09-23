import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/services/api.dart';
import 'package:urbansensor/src/streams/report_stream.dart';

class ApiReport {
  static final ApiReport _instance = ApiReport._();

  factory ApiReport() => _instance;

  ApiReport._();

  final String _url = Api().url;
  final String _domain = Api().domain;
  ReportStream _stream = ReportStream();

  int _page = 1;
  int _searchPage = 1;

  bool _isSearching = false;

  bool _isSearchEmpty = false;

  List<Report>? _allReports = [];
  List<Report>? _allReportsByProject = [];
  List<Report>? _latestReports = [];
  List<Report>? _searchedProjects = [];

  Future getLatestReport() async {
    final _headersTk = await Api().getHeadersTk();

    final res =
    await http.get(Uri.parse('$_url/report?page=1'), headers: _headersTk);

    print('getLatestReport() STATUS CODE: ${res.statusCode}');

    if (res.statusCode != 200) {
      _stream.reportsSink([]);
      return false;
    }

    ReportRes reportRes = ReportRes.fromJson(json.decode(res.body));

    List<Report>? reports = reportRes.content;

    _latestReports = reports;
    _stream.reportsLatestSink(reports);

    return reports;
  }

  Future getReportsByProject({required String projectId}) async {
    final _headersTk = await Api().getHeadersTk();
    _stream.reportLoadedSink(false);
    final res = await http.get(
        Uri.parse('$_url/report/project?id=${projectId}&page=${_page}'),
        headers: _headersTk);

    print('getReportsByProject() STATUS CODE: ${res.statusCode}');

    if (res.statusCode != 200) {
      if (_page == 1) {
        _stream.reportsSink([]);
      } else {}
      _stream.reportLoadedSink(true);
      return false;
    }

    _page++;

    ReportRes reportRes = ReportRes.fromJson(json.decode(res.body));

    List<Report>? reports = reportRes.content;

    _allReports?.addAll(reports!);
    _stream.reportsSink(_allReports);
    _stream.reportLoadedSink(true);

    return true;
  }

  Future deleteReport({required String reportId}) async {
    final _headersTk = await Api().getHeadersTk();
    _stream.reportLoadedSink(false);
    final res = await http.delete(Uri.parse('$_url/report?id=$reportId'),
        headers: _headersTk);

    print('deleteReport() STATUS CODE: ${res.statusCode}');

    if (res.statusCode != 200) {
      _stream.reportLoadedSink(true);
      return false;
    }

    _latestReports?.removeWhere((element) => element.id == reportId);
    _stream.reportsSink(_latestReports);

    _stream.reportLoadedSink(true);
    return true;
  }

  Future clean() async {
    _page = 1;
    _searchPage = 1;
    _isSearching = false;
    _isSearchEmpty = false;
    _allReports = [];
  }

  Future<List<Report>?> getReportsByProjectMap(
      {required String projectId}) async {
    final _headersTk = await Api().getHeadersTk();
    _stream.reportLoadedSink(false);
    final res = await http.get(
        Uri.parse('$_url/report/project/last?id=$projectId'),
        headers: _headersTk);

    print('getReportsByProjectMap() STATUS CODE: ${res.statusCode}');

    if (res.statusCode != 200) {
      if (_page == 1) {
        _stream.reportsProjectSink([]);
      } else {}
      _stream.reportLoadedSink(true);
      return [];
    }

    ReportRes reportRes = ReportRes.fromJson(json.decode(res.body));


    List<Report>? reports = reportRes.content;
    _stream.reportsProjectMapSink(reports);
    _stream.reportLoadedSink(true);

    return reports;
  }


  bool get isSearching => _isSearching;

  set isSearching(bool value) {
    _isSearching = value;
  }

  List<Report>? get latestReports => _latestReports;
}
