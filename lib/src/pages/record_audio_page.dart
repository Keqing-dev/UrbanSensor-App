import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/utils/sound_player.dart';
import 'package:urbansensor/src/utils/sound_recorder.dart';
import 'package:urbansensor/src/widgets/file_type.dart';
import 'package:urbansensor/src/widgets/navigators/back_app_bar.dart';

import 'create_report_page.dart';

class RecordAudioPage extends StatefulWidget {
  const RecordAudioPage({Key? key}) : super(key: key);

  @override
  _RecordAudioPageState createState() => _RecordAudioPageState();
}

class _RecordAudioPageState extends State<RecordAudioPage> {
  final recorder = SoundRecorder();
  final player = SoundPlayer();
  Timer? timer;
  int timerText = 0;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    recorder.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'Parar' : 'Grabar';

    return Scaffold(
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${timerText}s',
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: isRecording ? Palettes.rose : Palettes.lightBlue),
                onPressed: () async {
                  await recorder.toggleRecording();
                  setState(() {
                    timerText = recorder.recordDuration;
                  });
                },
                icon: Icon(icon),
                label: Text(text),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: isPlaying ? Palettes.rose : Palettes.lightBlue),
                onPressed: () async {
                  await player.togglePlaying(whenFinished: () {});
                  setState(() {});
                  playTimer();
                },
                icon: Icon(!isPlaying ? UniconsLine.play : Icons.stop),
                label: const Text('Reproducir'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  String? audioLocation = await recorder.getFileUrl();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateReportPage(
                          fileType: FileType.mic,
                          recordDuration: '${recorder.recordDuration}',
                          audioLocation: '$audioLocation'),
                    ),
                  );
                },
                icon: const Icon(UniconsLine.arrow_right),
                label: const Text('Continuar'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void playTimer() {
    setState(() {
      timerText = 0;
      isPlaying = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (timerText < recorder.recordDuration) {
        setState(() {
          timerText++;
        });
      } else {
        setState(() {
          isPlaying = false;
        });
        timer.cancel();
      }
    });
  }
}
