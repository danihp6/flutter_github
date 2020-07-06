import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:extended_image/extended_image.dart';

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
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  @override
  void initState() {
    _image = widget.image;
    tabController = TabController(length: 2, vsync: this);
    provider = ExtendedFileImageProvider(_image);
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
        height: 400,
        width: 400,
        extendedImageEditorKey: editorKey,
        mode: ExtendedImageMode.editor,
        fit: BoxFit.contain,
        initEditorConfigHandler: (ExtendedImageState state) {
          return EditorConfig(
            maxScale: 8.0,
            cropRectPadding: const EdgeInsets.all(0),
            hitTestSize: 20.0,
            cropAspectRatio: 1,
          );
        },
      );
    }

    Future<void> crop([bool test = false]) async {
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

    final DateTime start = DateTime.now();
    final Uint8List result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    print('result.length = ${result.length}');

    final Duration diff = DateTime.now().difference(start);

    print('image_editor time : $diff');
    showToast('handle duration: $diff',
        duration: const Duration(seconds: 5), dismissOtherToast: true);

    showPreviewDialog(result);
  }

  void flip() {
    editorKey.currentState.flip();
  }

  void rotate(bool right) {
    editorKey.currentState.rotate(right: right);
  }


    double sat = 1;
    double bright = 1;
    double con = 1;

    Widget _buildSat() {
      return Slider(
        label: 'sat : ${sat.toStringAsFixed(2)}',
        onChanged: (double value) {
          setState(() {
            sat = value;
          });
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
        ),
      ),
      body: Column(
        children: <Widget>[
          AspectRatio(aspectRatio: 1, child: buildImage()),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.rotate_90_degrees_ccw,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        editorOption.addOption(
                            FlipOption(horizontal: true, vertical: false));
                        _image = await ImageEditor.editFileImageAndGetFile(
                            file: _image, imageEditorOption: editorOption);
                        setState(() {});
                      }),
                  
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
            Tab(
              icon: Icon(Icons.brightness_6)
            )
          ]),
    );
  }
}
