import 'package:http/http.dart' as http;
import 'package:urbansensor/src/models/report.dart';
import 'dart:convert';
import 'package:urbansensor/src/services/api.dart';

class ApiReport {
  final String _url = Api().url;
  final String _domain = Api().domain;

  int _page = 1;
  int _searchPage = 1;

  bool _isSearching = false;

  bool _isSearchEmpty = false;

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



}
