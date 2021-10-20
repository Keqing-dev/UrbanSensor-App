import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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

  bool isPlaying = false;

  //timer
  int maxRecTimeInMinute = 60;
  double percent = 0;
  int timeInSegCounter = 0;

  int timeInSeg = 0;
  int timeInMinute = 0;

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
    timer?.cancel();

    File? audioFile = File(recorder.pathToSaveAudio);
    audioFile.delete();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: _timer(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: recorder.isRecording ||
                                  recorder.recordDuration <= 0
                              ? null
                              : () async {
                                  await player.togglePlaying(
                                      whenFinished: () {});
                                  recordTimer(conditional: player.isPlaying);
                                },
                          child: Icon(
                            UniconsLine.play,
                            color: player.isPlaying
                                ? Palettes.rose
                                : recorder.isRecording ||
                                        recorder.recordDuration <= 0
                                    ? Palettes.gray3
                                    : Palettes.lightBlue,
                          ),
                        ),
                      ),
                      Container(
                        color: Palettes.gray3,
                        width: 1,
                        height: 30,
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: player.isPlaying
                              ? null
                              : () async {
                                  await recorder.toggleRecording();
                                  recordTimer(
                                      conditional: recorder.isRecording);
                                },
                          child: Icon(
                            UniconsLine.microphone,
                            color: recorder.isRecording
                                ? Palettes.rose
                                : player.isPlaying
                                    ? Palettes.gray3
                                    : Palettes.lightBlue,
                          ),
                        ),
                      ),
                      Container(
                        color: Palettes.gray3,
                        width: 1,
                        height: 30,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: recorder.recordDuration <= 0 ||
                                  recorder.isRecording
                              ? null
                              : () async {
                                  String? audioLocation =
                                      await recorder.getFileUrl();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateReportPage(
                                          fileType: FileType.mic,
                                          recordDuration:
                                              '${recorder.recordDuration}',
                                          audioLocation: '$audioLocation'),
                                    ),
                                  );
                                },
                          child: Icon(
                            UniconsLine.arrow_right,
                            color: recorder.recordDuration <= 0 ||
                                    recorder.isRecording
                                ? Palettes.gray3
                                : Palettes.lightBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Text(
                'Puedes grabar un 1 hora de audio.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timer() {
    return CircularPercentIndicator(
      percent: percent,
      animation: true,
      animateFromLastPercent: true,
      radius: 250,
      lineWidth: 20,
      curve: Curves.linear,
      arcType: ArcType.FULL,
      arcBackgroundColor: const Color.fromRGBO(184, 199, 203, 1),
      progressColor: Palettes.rose,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$maxRecTimeInMinute min',
            style: const TextStyle(fontSize: 50),
          ),
          Text(
            '$timeInMinute:$timeInSeg mm:ss',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  void recordTimer({required bool conditional}) {
    if (!conditional) {
      timer?.cancel();
      setState(() {});
    } else {
      setState(() {
        timeInSegCounter = 0;
        timeInSeg = 0;
        timeInMinute = 0;
        isPlaying = true;
      });
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (conditional &&
            timeInMinute < 60 &&
            timeInSegCounter < recorder.recordDuration) {
          setState(() {
            timeInSeg++;
            timeInSegCounter++;

            if (timeInSeg > 59) {
              timeInSeg = 0;
              timeInMinute++;
            }
            percent = (timeInSegCounter / 60) / maxRecTimeInMinute;
            if (percent > 1.0) {
              setState(() {
                timeInSeg = 0;
                percent = 1;
              });
              timer.cancel();
            }
          });
        } else {
          timer.cancel();
          setState(() {});
        }
      });
    }
  }
}
