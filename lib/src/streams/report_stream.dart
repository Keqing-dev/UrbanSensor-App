

import 'dart:async';

import 'package:urbansensor/src/models/report.dart';



class ReportStream{

  static final ReportStream _reportStream = ReportStream._();


  factory ReportStream(){
    return _reportStream;
  }

  ReportStream._();


  StreamController<List<Report>?> _reportsStreamController = StreamController.broadcast();
  Function(List<Report>?) get reportsSink => _reportsStreamController.sink.add;
  Stream<List<Report>?> get reportsStream => _reportsStreamController.stream;


  StreamController<bool> _reportsLoadedStreamController = StreamController.broadcast();
  Function(bool) get reportLoadedSink => _reportsLoadedStreamController.sink.add;
  Stream<bool> get reportLoadedStream => _reportsLoadedStreamController.stream;


  void disposeStream(){
    _reportsStreamController.close();
    _reportsLoadedStreamController.close();
  }


}