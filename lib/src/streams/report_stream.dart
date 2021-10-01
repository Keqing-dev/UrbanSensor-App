import 'dart:async';

import 'package:urbansensor/src/models/report.dart';

class ReportStream {
  static final ReportStream _reportStream = ReportStream._();

  factory ReportStream() {
    return _reportStream;
  }

  ReportStream._();

  StreamController<List<Report>?> _reportsStreamC =
      StreamController.broadcast();

  Function(List<Report>?) get reportsSink => _reportsStreamC.sink.add;

  Stream<List<Report>?> get reportsStream => _reportsStreamC.stream;

  StreamController<List<Report>?> _reportsLatestStreamC =
      StreamController.broadcast();

  Function(List<Report>?) get reportsLatestSink =>
      _reportsLatestStreamC.sink.add;

  Stream<List<Report>?> get reportsLatestStream => _reportsLatestStreamC.stream;

  //Maps
  StreamController<List<Report>?> _reportsProjectStreamC =
      StreamController.broadcast();

  Function(List<Report>?) get reportsProjectSink =>
      _reportsProjectStreamC.sink.add;

  Stream<List<Report>?> get reportsProjectStream =>
      _reportsProjectStreamC.stream;

  StreamController<List<Report>?> _reportsProjectMapStreamC =
      StreamController.broadcast();

  Function(List<Report>?) get reportsProjectMapSink =>
      _reportsProjectMapStreamC.sink.add;

  Stream<List<Report>?> get reportsProjectMapStream =>
      _reportsProjectMapStreamC.stream;

  StreamController<bool> _reportsLoadedStreamController =
      StreamController.broadcast();

  Function(bool) get reportLoadedSink =>
      _reportsLoadedStreamController.sink.add;

  Stream<bool> get reportLoadedStream => _reportsLoadedStreamController.stream;

  StreamController<List<Report>?> get reportsProjectMapStreamC =>
      _reportsProjectMapStreamC;

  void disposeStream() {
    _reportsStreamC.close();
    _reportsLatestStreamC.close();
    _reportsLoadedStreamController.close();
    _reportsProjectMapStreamC.close();
    _reportsProjectStreamC.close();
  }
}
