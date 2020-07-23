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
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Widgets/scroll_column_expandable.dart';
import '../Controller/gallery.dart';
import '../Widgets/floating_text.dart';

List<BlendMode> blendModes = [
  BlendMode.color,
  BlendMode.saturation,
];

class ImageEditorPage extends StatefulWidget {
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
  BoxFit imageFit = BoxFit.cover;

  Color textColor = Colors.white;
  bool labelTextActived = false;
  double labelTextHeight = 100;

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

    void flipHorizontally() {
      transform =
          transform.flipHorizontally(origin: Offset(imageSize.width / 2, 0));
      setState(() {});
    }

    void flipVertically() {
      double dy = labelTextActived
          ? (imageSize.width - labelTextHeight) / 2
          : imageSize.width / 2;
      transform = transform.flipVertically(origin: Offset(0, dy));
      setState(() {});
    }

    void rotate(double degrees) {
      double height = labelTextActived
          ? imageSize.height - labelTextHeight
          : imageSize.height;
      Size size = Size(imageSize.width, height);
      transform = transform.rotateByCenterDegrees(degrees, size);
      setState(() {});
    }

    restore() {
      _imageMedia = widget.imageMedia;
      setState(() {});
    }

    changeFit() {
      setState(() {
        if (imageFit == BoxFit.cover)
          imageFit = BoxFit.contain;
        else
          imageFit = BoxFit.cover;
      });
    }

    activeLabelText() {
      setState(() {
        labelTextActived = !labelTextActived;
      });
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
              onPressed: () => navigator.pop(context)),
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
                  navigator.pop(context);
                  widget.onMediaSelected(context, _imageMedia);
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
                    return Column(
                      children: <Widget>[
                        if (labelTextActived)
                          Container(
                              height: labelTextHeight, color: Colors.white),
                        Container(
                          transform: transform.matrix4,
                          width: imageSize.width,
                          height: labelTextActived
                              ? imageSize.height - labelTextHeight
                              : imageSize.height,
                          child: Image.memory(_imageMedia.image,
                              fit: imageFit,
                              color: colorFilter,
                              colorBlendMode: blendMode),
                        ),
                      ],
                    );
                  }),
                ),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        height: 80,
                        child: FittedBox(
                          child: IconButton(
                              icon: Icon(
                                Icons.settings_overscan,
                                color: Colors.black,
                              ),
                              onPressed: changeFit),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FittedBox(
                            child: IconButton(
                                icon: Icon(
                                  Icons.flip,
                                  color: Colors.black,
                                ),
                                onPressed: flipHorizontally),
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
                                onPressed: flipVertically),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
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
                  ),
                ],
              ),
              ScrollColumnExpandable(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 80,
                          child: FittedBox(
                            child: IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.black,
                ),
                onPressed: removeAllFloatingButton),
                          ),
                        ),
                        SizedBox(
                          height: 80,
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
                        SizedBox(
                          height: 80,
                          child: FittedBox(
                            child: IconButton(
                icon: Icon(
                  Icons.label,
                  color: Colors.black,
                ),
                onPressed: activeLabelText),
                          ),
                        ),
                      ],
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
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                shape: BoxShape.circle),
                            child: FittedBox(child: Icon(Icons.clear)),
                          ),
                          onTap: colorFilter != null
                              ? () {
                                  colorFilter = null;
                                  setState(() {});
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(children: <Widget>[
                      Expanded(
                        child: ListWheelScrollView(
                          itemExtent: 50,
                          diameterRatio: 2,
                          physics: FixedExtentScrollPhysics(),
                          squeeze: 0.9,
                          children: blendModes
                              .map((mode) => Center(
                                  child: Text(
                                      mode.toString()[10].toUpperCase() +
                                          mode.toString().substring(11),
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: mode == blendMode
                                              ? Theme.of(context).accentColor
                                              : Colors.black))))
                              .toList(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              blendMode = blendModes[index];
                            });
                          },
                        ),
                      ),
                      Expanded(
                          child: GestureDetector(
                        child: colorFilter == null
                            ? Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    shape: BoxShape.circle),
                                child: FittedBox(child: Icon(Icons.remove)),
                              )
                            : Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    border: colorFilter == Colors.white
                                        ? Border.all(width: 1)
                                        : null,
                                    color: colorFilter,
                                    shape: BoxShape.circle),
                              ),
                        onTap: () async {
                          colorFilter = await buildColorsBottomSheet(context);
                          setState(() {});
                        },
                      ))
                      //           )
                    ]),
                  ),
                ],
              ),
              // SizedBox(
              //   width: 120,
              //   height: 200,
              //   child: ListWheelScrollView(
              //     itemExtent: 50,
              //     diameterRatio: 2,
              //     squeeze: 0.9,
              //     physics: FixedExtentScrollPhysics(),
              //     children: _buildColors(),
              //     onSelectedItemChanged: (index) {
              //       setState(() {
              //         if (index == 0)
              //           colorFilter = null;
              //         else
              //           colorFilter = colors[index - 1];
              //       });
              //     },
              //   ),
              // ),
              // SizedBox(
              //   width: 120,
              //   height: 200,
              //   child: ListWheelScrollView(
              //     itemExtent: 50,
              //     diameterRatio: 2,
              //     physics: FixedExtentScrollPhysics(),
              //     squeeze: 0.9,
              //     children: blendModes
              //         .map((blendMode) => Center(
              //             child: Text(
              //                 blendMode.toString()[10].toUpperCase() +
              //                     blendMode.toString().substring(11),
              //                 style: TextStyle(fontSize: 20))))
              //         .toList(),
              //     onSelectedItemChanged: (index) {
              //       setState(() {
              //         blendMode = blendModes[index];
              //       });
              //     },
              //   ),
              // )
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

  // List<Widget> _buildColors() {
  //   List<Widget> colorWidgets = colors
  //       .map((color) => Container(
  //             decoration: BoxDecoration(
  //                 border: color == Colors.white ? Border.all(width: 1) : null,
  //                 color: color,
  //                 shape: BoxShape.circle),
  //           ))
  //       .toList();
  //   colorWidgets.insert(
  //       0,
  //       Container(
  //         decoration: BoxDecoration(
  //             border: Border.all(width: 1), shape: BoxShape.circle),
  //         child: FittedBox(child: Icon(Icons.clear)),
  //       ));
  //   return colorWidgets;
  // }

}






