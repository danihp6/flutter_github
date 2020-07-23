import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/gallery.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/Template.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

List<CameraDescription> cameras;

class TemplateOverImageCameraPage extends StatefulWidget {
  Template template;
  TemplateOverImageCameraPage({@required this.template});
  @override
  _TemplateOverImageCameraPageState createState() =>
      _TemplateOverImageCameraPageState();
}

class _TemplateOverImageCameraPageState
    extends State<TemplateOverImageCameraPage> {
  CameraController controller;
  CameraDescription camera;
  String imagePath;
  GlobalKey _globalKey = new GlobalKey();
  Uint8List result;
  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      List cameras = value;
      camera = cameras[1];
      controller = CameraController(camera, ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

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

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void onTakePictureButtonPressed() async {
    result = await File(await takePicture()).readAsBytes();
    setState(() {});
  }

  Future getMedia() async {
    Uint8List image = await _capturePng();
    return ImageMedia(image, 1);
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Text(
            widget.template.name,
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: result != null
                    ? () async {
                        navigator.pop(context);
                        navigator.goUploadPublication(
                            context, getMedia, widget.template);
                      }
                    : null)
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            RepaintBoundary(
              key: _globalKey,
              child: Container(
                width: size,
                height: size,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      left: 100,
                      child: Container(
                        transform: Matrix4Transform().scale(0.6).matrix4,
                        width: size,
                        height: size / controller.value.aspectRatio,
                        child: result == null
                            ? CameraPreview(controller)
                            : Container(
                                transform: Matrix4Transform()
                                    .flipHorizontally(
                                        origin: Offset(size / 2, 0))
                                    .matrix4,
                                child: Image.memory(result)),
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl: widget.template.image,
                      width: size,
                      height: size,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: FittedBox(
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        color: Theme.of(context).accentColor,
                        onPressed:
                            controller != null && controller.value.isInitialized
                                ? onTakePictureButtonPressed
                                : null,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: IconButton(
                      icon: Icon(Icons.clear),
                      color: Theme.of(context).accentColor,
                      onPressed: result != null
                          ? () {
                              result = null;
                              setState(() {});
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
