import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:media_gallery/media_gallery.dart';

import 'package:fitted_text_field_container/fitted_text_field_container.dart';

import 'package:extended_image_library/extended_image_library.dart';
import '../Controller/gallery.dart';

List<Color> colors = [
  Colors.black,
  Colors.white,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.blue,
  Colors.green,
  Colors.pink,
  Colors.purple,
  Colors.lime,
  Colors.brown,
  Colors.teal,
];

List<BlendMode> blendModes = [
  BlendMode.color,
  BlendMode.saturation,
  BlendMode.difference,
  BlendMode.plus,
  BlendMode.modulate,
  BlendMode.screen,
  BlendMode.overlay,
  BlendMode.darken,
  BlendMode.lighten,
  BlendMode.colorDodge,
  BlendMode.colorBurn,
  BlendMode.hardLight,
  BlendMode.softLight,
  BlendMode.exclusion,
  BlendMode.multiply,
  BlendMode.hue,
  BlendMode.luminosity
];

class ImageEditorPage<File> extends StatefulWidget {
  ImageMedia imageMedia;
  Function onMediaSelected;
  ImageEditorPage({@required this.imageMedia, @required this.onMediaSelected});

  @override
  _ImageEditorPageState createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage>
    with SingleTickerProviderStateMixin {
  ImageMedia _imageMedia;
  TabController tabController;
  double sat;
  double bright;
  double con;
  GlobalKey _globalKey = new GlobalKey();
  bool isTextOptionsVisible = true;
  List<Key> floatingTexts = [];
  Color colorFilter;
  BlendMode blendMode = BlendMode.color;
  Matrix4Transform transform = Matrix4Transform();
  Size imageSize;

  Color textColor = Colors.white;

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

  @override
  void initState() {
    _imageMedia = widget.imageMedia;
    // _image = widget.imageMedia.image;
    tabController = TabController(length: 3, vsync: this);

    sat = 1;
    bright = 1;
    con = 1;
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    removeFloatingButton(Key key) {
      setState(() {
        floatingTexts.remove(key);
      });
    }

    removeAllFloatingButton() {
      setState(() {
        floatingTexts.clear();
      });
    }

    addFloatingButton() {
      if (floatingTexts.length < 5)
        setState(() {
          floatingTexts.add(UniqueKey());
        });
    }

    showTextOptions() {
      setState(() {
        isTextOptionsVisible = !isTextOptionsVisible;
        print(isTextOptionsVisible);
      });
    }

    void flip() {
      transform =
          transform.flipHorizontally(origin: Offset(imageSize.width / 2, 0));
      setState(() {});
    }

    void rotate(double degrees) {
      transform = transform.rotateByCenterDegrees(degrees, imageSize);
      setState(() {});
    }

    restore() {
      _imageMedia = widget.imageMedia;
      setState(() {});
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
                  isTextOptionsVisible = false;
                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 10), () {});
                  _imageMedia.image = await _capturePng();
                  Navigator.pop(context);
                  widget.onMediaSelected(_imageMedia);
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
                    aspectRatio: widget.imageMedia.aspectRatio,
                    child: LayoutBuilder(builder: (context, constraints) {
                      imageSize = constraints.biggest;
                      return Container(
                          transform: transform.matrix4,
                          child: Image.memory(_imageMedia.image,
                              fit: BoxFit.cover,
                              color: colorFilter,
                              colorBlendMode: blendMode));
                    })),
                Positioned.fill(
                  child: Stack(
                    children: floatingTexts
                        .map((key) => FloatingText(
                              remove: removeFloatingButton,
                              key: key,
                              isTextOptionsVisible: isTextOptionsVisible,
                            ))
                        .toList(),
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
                  Expanded(
                    child: FittedBox(
                      child: IconButton(
                          icon: Icon(
                            Icons.flip,
                            color: Colors.black,
                          ),
                          onPressed: flip),
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      child: IconButton(
                          icon: LayoutBuilder(
                            builder: (context, constraints) => Container(
                                transform: Matrix4Transform()
                                    .rotateByCenterDegrees(
                                        90, constraints.biggest)
                                    .left(constraints.maxWidth / 4)
                                    .matrix4,
                                child: Icon(
                                  Icons.flip,
                                  color: Colors.black,
                                )),
                          ),
                          onPressed: flip),
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      child: IconButton(
                          icon: Icon(
                            Icons.rotate_right,
                            color: Colors.black,
                          ),
                          onPressed: () => rotate(90)),
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      child: IconButton(
                          icon: Icon(
                            Icons.rotate_left,
                            color: Colors.black,
                          ),
                          onPressed: () => rotate(-90)),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: FittedBox(
                      child: IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.black,
                          ),
                          onPressed: removeAllFloatingButton),
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      child: IconButton(
                          icon: Icon(
                            isTextOptionsVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: showTextOptions),
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          onPressed: addFloatingButton),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 120,
                    height: 200,
                    child: ListWheelScrollView(
                      itemExtent: 50,
                      diameterRatio: 2,
                      squeeze: 0.9,
                      physics: FixedExtentScrollPhysics(),
                      children: _buildColors(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          if (index == 0)
                            colorFilter = null;
                          else
                            colorFilter = colors[index - 1];
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 200,
                    child: ListWheelScrollView(
                      itemExtent: 50,
                      diameterRatio: 2,
                      physics: FixedExtentScrollPhysics(),
                      squeeze: 0.9,
                      children: blendModes
                          .map((blendMode) => Center(
                              child: Text(
                                  blendMode.toString()[10].toUpperCase() +
                                      blendMode.toString().substring(11),
                                  style: TextStyle(fontSize: 20))))
                          .toList(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          blendMode = blendModes[index];
                        });
                      },
                    ),
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
            Tab(icon: Icon(Icons.flip)),
            Tab(icon: Icon(Icons.text_fields)),
            Tab(icon: Icon(Icons.brightness_6)),
          ]),
    );
  }

  List<Widget> _buildColors() {
    List<Widget> colorWidgets = colors
        .map((color) => Container(
              decoration: BoxDecoration(
                  border: color == Colors.white ? Border.all(width: 1) : null,
                  color: color,
                  shape: BoxShape.circle),
            ))
        .toList();
    colorWidgets.insert(
        0,
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1), shape: BoxShape.circle),
          child: FittedBox(child: Icon(Icons.clear)),
        ));
    return colorWidgets;
  }
}

class FloatingText extends StatefulWidget {
  Function remove;
  Key key;
  bool isTextOptionsVisible;
  FloatingText({@required this.remove, this.key, this.isTextOptionsVisible});
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
  bool _isTextOptionsVisible;

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isTextOptionsVisible = widget.isTextOptionsVisible;
    print(_isTextOptionsVisible);
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
          if (_isTextOptionsVisible)
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
                  onTap: () => widget.remove(widget.key),
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
      onTap: () async {
        Color color = await buildColorsBottomSheet(context);
        print(color);
        if (color != null) changeColor(color);
      },
    );
  }
}

Future<Color> buildColorsBottomSheet(BuildContext context) {
  return showModalBottomSheet(
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
                          padding: const EdgeInsets.all(2), child: Container()),
                    ),
                  ),
                ),
                onTap: () {
                  print(colors[index]);
                  Navigator.pop(context, colors[index]);
                }),
          ),
        ),
      );
    },
  );
}
