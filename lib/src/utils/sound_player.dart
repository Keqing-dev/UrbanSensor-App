import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer;
  final pathToReadAudio = 'audio_example.aac';
  bool _isPlayerInitialised = false;

  bool get isPlaying => _audioPlayer!.isPlaying;

  Future init() async {
    _audioPlayer = FlutterSoundPlayer();

    await _audioPlayer!.openAudioSession();
    _isPlayerInitialised = true;
  }

  Future dispose() async {
    await _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
    _isPlayerInitialised = false;
  }

  Future _play(VoidCallback whenFinished) async {
    if (!_isPlayerInitialised) return;
    await _audioPlayer!.startPlayer(
      fromURI: pathToReadAudio,
      whenFinished: whenFinished,
    );
  }

  Future _stop() async {
    if (!_isPlayerInitialised) return;
    await _audioPlayer!.stopPlayer();
  }

  Future togglePlaying({required VoidCallback whenFinished}) async {
    if (_audioPlayer!.isStopped) {
      await _play(whenFinished);
    } else {
      await _stop();
    }
  }
}
