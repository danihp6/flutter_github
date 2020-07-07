import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_editor/image_editor.dart';
import 'package:extended_image/extended_image.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:oktoast/oktoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../Widgets/scaling_gesture_detector.dart';

class ImageEditorPage<File> extends StatefulWidget {
  File image;
  ImageEditorPage({@required this.image});

  @override
  _ImageEditorPageState createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage>
    with SingleTickerProviderStateMixin {
  Uint8List _image;
  TabController tabController;
  double sat;
  double bright;
  double con;
  GlobalKey _globalKey = new GlobalKey();
  TextEditingController textController;
  bool inside = false;
  Offset textOffset = Offset.zero;
  Offset textPoint = Offset.zero;
  double _scaleFactor = 40.0;
double _baseScaleFactor = 1.0;

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      inside = true;
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
//      String bs64 = base64Encode(pngBytes);
//      print(pngBytes);
//      print(bs64);
      print('png done');
      setState(() {
        _image = pngBytes;
        inside = false;
      });
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _image = widget.image;
    tabController = TabController(length: 3, vsync: this);
    
    
    sat = 1;
    bright = 1;
    con = 1;
    textController = TextEditingController(text: 'Texto');
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    

    // void flip() {
    //   editorKey.currentState.flip();
    // }

    // void rotate(bool right) {
    //   editorKey.currentState.rotate(right: right);
    // }

    // restore() {
    //   editorKey.currentState.reset();
    //   _image = widget.image;
    //   provider = ExtendedFileImageProvider(_image);
    //   setState(() {});
    // }

    Widget _buildSat() {
      return Slider(
        label: 'sat : ${sat.toStringAsFixed(2)}',
        onChanged: (double value) {
          sat = value;
          setState(() {});
        },
        value: sat,
        min: 0,
        max: 2,
      );
    }

    Widget _buildBrightness() {
      return Slider(
        label: 'brightness : ${bright.toStringAsFixed(2)}',
        onChanged: (double value) {
          setState(() {
            bright = value;
          });
        },
        value: bright,
        min: 0,
        max: 2,
      );
    }

    Widget _buildCon() {
      return Slider(
        label: 'con : ${con.toStringAsFixed(2)}',
        onChanged: (double value) {
          setState(() {
            con = value;
          });
        },
        value: con,
        min: 0,
        max: 4,
      );
    }

    // Future<File> save() async {
    //   final ExtendedImageEditorState state = editorKey.currentState;
    //   final Rect rect = state.getCropRect();
    //   final EditActionDetails action = state.editAction;
    //   final double radian = action.rotateAngle;

    //   final bool flipHorizontal = action.flipY;
    //   final bool flipVertical = action.flipX;
    //   // final img = await getImageFromEditorKey(editorKey);
    //   final Uint8List img = state.rawImageData;

    //   final ImageEditorOption option = ImageEditorOption();

    //   option.addOption(ClipOption.fromRect(rect));
    //   option.addOption(
    //       FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    //   if (action.hasRotateAngle) {
    //     option.addOption(RotateOption(radian.toInt()));
    //   }

    //   option.addOption(ColorOption.saturation(sat));
    //   option.addOption(ColorOption.brightness(bright));
    //   option.addOption(ColorOption.contrast(con));

    //   option.outputFormat = const OutputFormat.png(88);

    //   final Uint8List result = await ImageEditor.editImage(
    //     image: img,
    //     imageEditorOption: option,
    //   );

    //   String path = await ImageGallerySaver.saveImage(result);
    //   File file = File(path.substring(7));
    //   return file;
    // }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context)),
          title: IconButton(icon: Icon(Icons.restore), onPressed: null),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.done),
                onPressed: () async {
                  // Navigator.pop(context, await save());
                })
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          RepaintBoundary(
            key: _globalKey,
            child: Stack(
              children: <Widget>[
                AspectRatio(aspectRatio: 1, child: Image.memory(_image)),
                Positioned(
                  left: textOffset.dx,
                  top: textOffset.dy,
                  child: ScalingGestureDetector(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: textController,
                        style: TextStyle(
                          fontSize: _scaleFactor,
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    onPanStart: (initialPoint) {
                      setState(() {
                        textPoint = initialPoint;
                      });
                    },
                    onPanUpdate: (details,delta) {
                      setState(() {
                        textOffset = textPoint + delta;
                      });
                    },
                    onScaleStart: (details) {
                      print('scalestart');
                      _baseScaleFactor = _scaleFactor;
                    },
                    onScaleUpdate: (details,scale) {
                      
                      setState(() {
                        _scaleFactor = _baseScaleFactor * scale;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.flip,
                        color: Colors.black,
                        size: 50,
                      ),
                      onPressed: null),
                  IconButton(
                      icon: Icon(
                        Icons.rotate_right,
                        color: Colors.black,
                        size: 50,
                      ),
                      onPressed: () => null),
                  IconButton(
                      icon: Icon(
                        Icons.rotate_left,
                        color: Colors.black,
                        size: 50,
                      ),
                      onPressed: () => null),
                ],
              ),
              SliderTheme(
                data: const SliderThemeData(
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildSat(),
                    _buildBrightness(),
                    _buildCon(),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Añadir texto'),
                    onPressed: () async {
                      _capturePng();
                    },
                  )
                ],
              ),
            ]),
          )
        ],
      ),
      bottomNavigationBar: TabBar(
          labelColor: Colors.deepOrange,
          unselectedLabelColor: Colors.black,
          indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 0)),
          controller: tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.flip),
            ),
            Tab(icon: Icon(Icons.brightness_6)),
            Tab(icon: Icon(Icons.text_fields)),
          ]),
    );
  }
}
