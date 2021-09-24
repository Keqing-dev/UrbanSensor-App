import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urbansensor/src/utils/general_util.dart';
import 'package:urbansensor/src/widgets/snack_bar_c.dart';
import 'package:video_player/video_player.dart';

class TestComponents extends StatefulWidget {
  const TestComponents({Key? key}) : super(key: key);

  @override
  State<TestComponents> createState() => _TestComponentsState();
}

class _TestComponentsState extends State<TestComponents> {
  File? _video;

  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _captureVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    /*  _videoPlayerController = VideoPlayerController.network(
        'https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4');*/
    _videoPlayerController = VideoPlayerController.file(_video!);

    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _video == null
            ? Center(
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                ),
              )
            : Center(
                child: Container(
                  child: _chewieController != null &&
                          _chewieController!
                              .videoPlayerController.value.isInitialized
                      ? Chewie(
                          controller: _chewieController!,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text('Loading'),
                          ],
                        ),
                ),
              ),
      ),
    );
  }

  void _captureVideo() async {
    print(GeneralUtil.isVideoFormat('newString'));

    final ImagePicker _picker = ImagePicker();

    if (await Permission.camera.request().isGranted) {
      // Capture a video
      final XFile? video = await _picker.pickVideo(
          source: ImageSource.camera, maxDuration: const Duration(seconds: 10));

      if (video == null) {
        Navigator.of(context).pop();
      }

      File? videoPreview = File.fromUri(Uri(path: video?.path));

      setState(() {
        _video = videoPreview;
      });
      initializePlayer();
    } else {
      Navigator.of(context).pop();
      SnackBarC.showSnackbar(
          message: 'Debes aceptar los permisos', context: context);
    }
  }
}
