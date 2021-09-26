import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urbansensor/src/utils/loading_indicators_c.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  const VideoViewer({Key? key, required this.file, this.url}) : super(key: key);

  final File file;
  final String? url;

  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    if (widget.url != null) {
      _videoPlayerController = VideoPlayerController.network('${widget.url}');
    } else {
      _videoPlayerController = VideoPlayerController.file(widget.file);
    }

    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Palettes.rose,
        backgroundColor: Palettes.lightBlue,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.transparent,
      ),
      autoInitialize: true,
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeLeft],
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.8),
      body: Center(
        child: Container(
          child: _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? Stack(
                  children: [
                    Chewie(
                      controller: _chewieController!,
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingIndicatorsC.ballRotateChase,
                    const SizedBox(height: 20),
                    const Text(
                      'Cargando',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
