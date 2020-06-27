import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras;

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController controller;
  List<CameraDescription> cameras = <CameraDescription>[];
  CameraDescription camera;

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
      body: Container(
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
    );
  }
}
