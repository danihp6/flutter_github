import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:media_gallery/media_gallery.dart';

import 'package:fitted_text_field_container/fitted_text_field_container.dart';

class ImageEditorPage<File> extends StatefulWidget {
  Uint8List bytes;
  Function onMediaSelected;
  ImageEditorPage({@required this.bytes, @required this.onMediaSelected});

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
  List<FloatingText> floatingTexts = [];
  bool isTextOptionsVisible = true;

  bool inside = false;

  GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  Color textColor = Colors.white;

  // _getTextSize(_) {
  //   final RenderBox renderBox = _keyText.currentContext.findRenderObject();
  //   final size = renderBox.size;
  //   print("SIZE $size");
  //   _textSize = size;
  //   setState(() {});
  // }

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
    _image = widget.bytes;
    tabController = TabController(length: 3, vsync: this);

    sat = 1;
    bright = 1;
    con = 1;
    // WidgetsBinding.instance.addPostFrameCallback(_getTextSize);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  removeFloatingButton(FloatingText floatingText) {
    setState(() {
      floatingTexts.remove(floatingText);
    });
  }

  addFloatingButton() {
    if (floatingTexts.length < 5)
      setState(() {
        floatingTexts.add(FloatingText(
          remove: removeFloatingButton,
          key: UniqueKey(),
          isTextOptionsVisible: isTextOptionsVisible,
        ));
      });
  }

  showTextOptions(){
    setState(() {
      isTextOptionsVisible = !isTextOptionsVisible;
      print(isTextOptionsVisible);
    });
  }

  @override
  Widget build(BuildContext context) {
    // _getTextSize('');
    void flip() {
      editorKey.currentState.flip();
    }

    void rotate(bool right) {
      editorKey.currentState.rotate(right: right);
    }

    restore() {
      editorKey.currentState.reset();
      _image = widget.bytes;
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

    Future<Uint8List> save() async {
      final ExtendedImageEditorState state = editorKey.currentState;
      final EditActionDetails action = state.editAction;
      final double radian = action.rotateAngle;

      final bool flipHorizontal = action.flipY;
      final bool flipVertical = action.flipX;
      final Uint8List img = state.rawImageData;

      final ImageEditorOption option = ImageEditorOption();

      option.addOption(
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
      if (action.hasRotateAngle) {
        option.addOption(RotateOption(radian.toInt()));
      }

      option.addOption(ColorOption.saturation(sat));
      option.addOption(ColorOption.brightness(bright));
      option.addOption(ColorOption.contrast(con));

      option.outputFormat = const OutputFormat.png(88);

      final Uint8List result = await ImageEditor.editImage(
        image: img,
        imageEditorOption: option,
      );

      return result;
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
          title: IconButton(icon: Icon(Icons.restore), onPressed: null),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.done),
                onPressed: () async {
                  String path = await ImageGallerySaver.saveImage(await save());
                  File file = File(path.substring(7));
                  widget.onMediaSelected(file, MediaType.image);
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
                AspectRatio(
                    aspectRatio: 1,
                    child: ExtendedImage(
                      image: ExtendedMemoryImageProvider(_image),
                      extendedImageEditorKey: editorKey,
                      mode: ExtendedImageMode.editor,
                      fit: BoxFit.contain,
                      initEditorConfigHandler: (ExtendedImageState state) {
                        return EditorConfig(
                            maxScale: 3.0,
                            cropRectPadding: const EdgeInsets.all(0),
                            hitTestSize: 20.0,
                            cropAspectRatio: 1,
                            initCropRectType: InitCropRectType.layoutRect,
                            lineColor: Colors.transparent,
                            cornerSize: Size.zero);
                      },
                    )),
                Positioned.fill(
                  child: Stack(
                    children: floatingTexts,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                                    IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                        size: 50,
                      ),
                      onPressed: (){}),
                  IconButton(
                      icon: Icon(
                        Icons.visibility,
                        color: Colors.black,
                        size: 50,
                      ),
                      onPressed: showTextOptions),
                  IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 50,
                      ),
                      onPressed: addFloatingButton),
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

class FloatingText extends StatefulWidget {
  Function remove;
  Key key;
  bool isTextOptionsVisible;
  FloatingText(
      {@required this.remove, this.key, this.isTextOptionsVisible = true});
  @override
  _FloatingTextState createState() => _FloatingTextState();
}

class _FloatingTextState extends State<FloatingText> {
  Offset textOffset = Offset.zero;
  double scaleFactor = 40.0;
  double baseScaleFactor = 1.0;
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController(text: 'Texto');
  GlobalKey<FittedTextFieldContainerState> keyText =
      GlobalKey<FittedTextFieldContainerState>();
  Color textColor = Colors.white;

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    changeColor(Color color) {
      setState(() {
        textColor = color;
      });
    }

    return Positioned(
      left: textOffset.dx,
      top: textOffset.dy,
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: FittedTextFieldContainer(
              key: keyText,
              child: TextField(
                keyboardType: TextInputType.multiline,
                scrollPhysics: NeverScrollableScrollPhysics(),
                maxLines: null,
                controller: textController,
                focusNode: focusNode,
                style: TextStyle(fontSize: scaleFactor, color: textColor),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  keyText.currentState.resize();
                },
              ),
            ),
            onPanStart: (initialPoint) {
              focusNode.unfocus();
            },
            onPanUpdate: (details) {
              setState(() {
                textOffset = textOffset + details.delta;
              });
            },
          ),
          if (widget.isTextOptionsVisible)
            Row(
              children: <Widget>[
                GestureDetector(
                  child: SizedBox(
                    width: scaleFactor < 40 ? 20 : scaleFactor * 0.5,
                    child: FittedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 2,
                          child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(Icons.delete)),
                        ),
                      ),
                    ),
                  ),
                  onTap: () => widget.remove(this.widget),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  child: SizedBox(
                    width: scaleFactor < 40 ? 20 : scaleFactor * 0.5,
                    child: FittedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 2,
                          child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(Icons.format_size)),
                        ),
                      ),
                    ),
                  ),
                  onPanUpdate: (details) {
                    focusNode.unfocus();

                    if (scaleFactor > 10 || details.delta.dy > 0)
                      setState(() {
                        scaleFactor += details.delta.dy;
                      });
                    keyText.currentState.resize();
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                TextColorButton(
                  scaleFactor: scaleFactor,
                  textColor: textColor,
                  changeColor: changeColor,
                ),
              ],
            )
        ],
      ),
    );
  }
}

class TextColorButton extends StatelessWidget {
  TextColorButton(
      {@required this.scaleFactor,
      @required this.textColor,
      @required this.changeColor});

  double scaleFactor;
  Color textColor;
  Function changeColor;

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.yellow,
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.pink,
      Colors.purple,
      Colors.lime
    ];

    return GestureDetector(
      child: SizedBox(
        width: scaleFactor < 40 ? 20 : scaleFactor * 0.5,
        child: FittedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Material(
              color: textColor.withOpacity(0.8),
              elevation: 2,
              child:
                  Padding(padding: const EdgeInsets.all(2), child: Container()),
            ),
          ),
        ),
      ),
      onTap: () {
        showBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemCount: colors.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(width: 5),
                  itemBuilder: (context, index) => GestureDetector(
                    child: FittedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                          color: colors[index],
                          elevation: 2,
                          child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container()),
                        ),
                      ),
                    ),
                    onTap: () => changeColor(colors[index]),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
