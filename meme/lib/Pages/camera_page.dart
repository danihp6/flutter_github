import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/gallery.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras;

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController controller;
  List<CameraDescription> cameras = <CameraDescription>[];
  CameraDescription camera;
  String imagePath;
  String videoPath;

  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      camera = cameras[0];
      controller = CameraController(camera, ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> takePicture() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    return filePath;
  }

  void onTakePictureButtonPressed() async {
    Uint8List image = await File(await takePicture()).readAsBytes();
    navigator.goUploadPublication(context, ImageMedia(image,1));
  }

  Future<String> startVideoRecording() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      print(e);
      rethrow;
    }
  }

  void changeCamera() {
    camera = camera == cameras[0] ? cameras[1] : cameras[0];
    controller = CameraController(camera, ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      File file = File(videoPath);
      navigator.goUploadPublication(context, VideoMedia(file, null,1));
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                          width: size,
                          height: size / controller.value.aspectRatio,
                          child: CameraPreview(controller)),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                    color: Colors.deepOrange,
                    iconSize: 30,
                    icon: Icon(Icons.rotate_90_degrees_ccw),
                    onPressed: changeCamera,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: FittedBox(
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      color: Theme.of(context).accentColor,
                      onPressed: controller != null &&
                              controller.value.isInitialized &&
                              !controller.value.isRecordingVideo
                          ? onTakePictureButtonPressed
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    child: IconButton(
                      icon: const Icon(Icons.videocam),
                      color: Theme.of(context).accentColor,
                      onPressed: controller != null &&
                              controller.value.isInitialized &&
                              !controller.value.isRecordingVideo
                          ? onVideoRecordButtonPressed
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    child: IconButton(
                      icon: controller != null &&
                              controller.value.isRecordingPaused
                          ? Icon(Icons.play_arrow)
                          : Icon(Icons.pause),
                      color: Theme.of(context).accentColor,
                      onPressed: controller != null &&
                              controller.value.isInitialized &&
                              controller.value.isRecordingVideo
                          ? (controller != null &&
                                  controller.value.isRecordingPaused
                              ? onResumeButtonPressed
                              : onPauseButtonPressed)
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    child: IconButton(
                      icon: const Icon(Icons.stop),
                      color: Colors.red,
                      onPressed: controller != null &&
                              controller.value.isInitialized &&
                              controller.value.isRecordingVideo
                          ? onStopButtonPressed
                          : null,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
