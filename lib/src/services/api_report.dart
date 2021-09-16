import 'package:http/http.dart' as http;
import 'package:urbansensor/src/models/report.dart';
import 'dart:convert';
import 'package:urbansensor/src/services/api.dart';
import 'package:urbansensor/src/streams/report_stream.dart';

class ApiReport {
  final String _url = Api().url;
  final String _domain = Api().domain;
  ReportStream _stream = ReportStream();

  int _page = 1;
  int _searchPage = 1;

  bool _isSearching = false;

  bool _isSearchEmpty = false;

  List<Report>? _allReports = [];
  List<Report>? _latestReports = [];
  List<Report>? _searchedProjects = [];

  Future getLatestReport() async {
    final _headersTk = await Api().getHeadersTk();

    final res =
        await http.get(Uri.parse('$_url/report?page=1'), headers: _headersTk);

    print('getLatestReport() STATUS CODE: ${res.statusCode}');

    ReportRes reportRes = ReportRes.fromJson(json.decode(res.body));

    List<Report>? reports = reportRes.content;

    return reports;
  }

  Future getReportsByProject({required String projectId}) async {
    final _headersTk = await Api().getHeadersTk();
    _stream.reportLoadedSink(false);

    final res = await http.get(
        Uri.parse('$_url/report/project?id=${projectId}&page=${_page}'),
        headers: _headersTk);

    if (res.statusCode != 200) {
      if (_page == 1) {
        _stream.reportsSink([]);
      } else {}
      _stream.reportLoadedSink(true);
      return false;
    }

    _page++;

    print('getReportsByProject() STATUS CODE: ${res.statusCode}');

    ReportRes reportRes = ReportRes.fromJson(json.decode(res.body));

    List<Report>? reports = reportRes.content;

    _allReports?.addAll(reports!);
    _stream.reportsSink(_allReports);
    _stream.reportLoadedSink(true);

    return true;
  }

  bool get isSearching => _isSearching;

  set isSearching(bool value) {
    _isSearching = value;
  }
}
