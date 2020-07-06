import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:extended_image/extended_image.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:oktoast/oktoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageEditorPage<File> extends StatefulWidget {
  File image;
  ImageEditorPage({@required this.image});

  @override
  _ImageEditorPageState createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage>
    with SingleTickerProviderStateMixin {
  File _image;
  TabController tabController;
  ImageProvider provider;
  GlobalKey<ExtendedImageEditorState> editorKey;
  double sat;
  double bright;
  double con;
  double _scale;
  @override
  void initState() {
    _image = widget.image;
    tabController = TabController(length: 3, vsync: this);
    editorKey = editorKey = GlobalKey<ExtendedImageEditorState>();
    provider = ExtendedFileImageProvider(_image);
    sat = 1;
    bright = 1;
    con = 1;
    _scale = 2;
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editorOption = ImageEditorOption();

    Widget buildImage() {
      return ExtendedImage(
        image: provider,
        extendedImageEditorKey: editorKey,
        mode: ExtendedImageMode.editor,
        fit: BoxFit.contain,
        initEditorConfigHandler: (ExtendedImageState state) {
          return EditorConfig(
            maxScale: 3.0,
            cropRectPadding: const EdgeInsets.all(10),
            hitTestSize: 20.0,
            cropAspectRatio: 1,
            initCropRectType: InitCropRectType.layoutRect,
          );
        },
        initGestureConfigHandler: (state) {
          return GestureConfig(
            cacheGesture: true,
            minScale: 0.8,
            animationMinScale: 0.7,
            maxScale: 3.0,
            animationMaxScale: 3.5,
            speed: 1.0,
            inertialSpeed: 100.0,
            initialScale: 1.0,
            inPageView: false,
            initialAlignment: InitialAlignment.center,
          );
        },
      );
    }

    void flip() {
      editorKey.currentState.flip();
    }

    void rotate(bool right) {
      editorKey.currentState.rotate(right: right);
    }

    restore() {
      editorKey.currentState.reset();
      _image = widget.image;
      provider = ExtendedFileImageProvider(_image);
      setState(() {});
    }

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

    Future<File> save() async {
      final ExtendedImageEditorState state = editorKey.currentState;
      final Rect rect = state.getCropRect();
      final EditActionDetails action = state.editAction;
      final double radian = action.rotateAngle;

      final bool flipHorizontal = action.flipY;
      final bool flipVertical = action.flipX;
      // final img = await getImageFromEditorKey(editorKey);
      final Uint8List img = state.rawImageData;

      final ImageEditorOption option = ImageEditorOption();

      option.addOption(ClipOption.fromRect(rect));
      option.addOption(
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
      if (action.hasRotateAngle) {
        option.addOption(RotateOption(radian.toInt()));
      }

      option.addOption(ColorOption.saturation(sat));
      option.addOption(ColorOption.brightness(bright));
      option.addOption(ColorOption.contrast(con));

      option.outputFormat = const OutputFormat.png(88);

      print(const JsonEncoder.withIndent('  ').convert(option.toJson()));

      final Uint8List result = await ImageEditor.editImage(
        image: img,
        imageEditorOption: option,
      );

      return File(await ImageGallerySaver.saveImage(result));
    }

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
          title: IconButton(icon: Icon(Icons.restore), onPressed: restore),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.done),
                onPressed: () async {
                  Navigator.pop(context, await save());
                })
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AspectRatio(
                  aspectRatio: 1,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      print(constraints.maxHeight);
                      return buildImage();
                    },
                  )),
              Text(
                'holaaa',
                style: TextStyle(color: Colors.white, fontSize: 40),
              )
            ],
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
                      onPressed: flip),
                  IconButton(
                      icon: Icon(
                        Icons.rotate_right,
                        color: Colors.black,
                        size: 50,
                      ),
                      onPressed: () => rotate(true)),
                  IconButton(
                      icon: Icon(
                        Icons.rotate_left,
                        color: Colors.black,
                        size: 50,
                      ),
                      onPressed: () => rotate(false)),
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
                      AddTextOption addTextOption = AddTextOption();
                      addTextOption.addText(
                        EditorText(
                          offset: const Offset(1000, 0),
                          text: 'hola',
                          fontSizePx: 100,
                          textColor: Colors.white,
                        ),
                      );
                      editorOption.addOption(addTextOption);
                      _image = await ImageEditor.editFileImageAndGetFile(
                        file: _image,
                        imageEditorOption: editorOption,
                      );
                      provider = ExtendedFileImageProvider(_image);
                      setState(() {});
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
