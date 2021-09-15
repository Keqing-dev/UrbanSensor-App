

import 'dart:async';

import 'package:urbansensor/src/models/project.dart';

class ProjectStream{

  static final ProjectStream _projectStream = ProjectStream._();


  factory ProjectStream(){
    return _projectStream;
  }

  ProjectStream._();


  StreamController<List<Project>?> _projectsStreamController = StreamController.broadcast();
  Function(List<Project>?) get projectsSink => _projectsStreamController.sink.add;
  Stream<List<Project>?> get projectsStream => _projectsStreamController.stream;


  StreamController<bool> _porjectsLoadedStreamController = StreamController.broadcast();
  Function(bool) get projectLoadedSink => _porjectsLoadedStreamController.sink.add;
  Stream<bool> get projectLoadedStream => _porjectsLoadedStreamController.stream;




  void disposeStream(){
    _projectsStreamController.close();
    _porjectsLoadedStreamController.close();
  }


}