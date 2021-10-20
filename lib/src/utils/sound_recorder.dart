import 'dart:async';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  final _pathToSaveAudio = 'audio_example.aac';

  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;

  bool get isRecording => _audioRecorder!.isRecording;

  get pathToSaveAudio => _pathToSaveAudio;

  int _recordDuration = 0;
  Timer? timer;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();

    if (!status.isGranted) {
      throw RecordingPermissionException('Microfono F');
    }

    await _audioRecorder!.openAudioSession();

    _isRecorderInitialised = true;
  }

  Future dispose() async {
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  Future _record() async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder!.startRecorder(
      toFile: _pathToSaveAudio,
    );
  }

  Future _stop() async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      _recordDuration = 0;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        _recordDuration++;
        if (_recordDuration > 3600) {
          timer.cancel();
          await _stop();
        }
      });
      await _record();
    } else {
      timer?.cancel();
      await _stop();
    }
  }

  int get recordDuration => _recordDuration;

  Future<String?> getFileUrl() async {
    return await _audioRecorder!.getRecordURL(path: _pathToSaveAudio);
  }
}
