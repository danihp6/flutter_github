import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_editor/image_editor.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Widgets/scroll_column_expandable.dart';

import '../Controller/gallery.dart';
import '../Widgets/floating_text.dart';
import 'gallery_page.dart';

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
  GlobalKey _globalKey = new GlobalKey();
  bool isTextOptionsVisible = true;
  List<Key> floatingTexts = [];
  Color colorFilter;
  BlendMode blendMode = BlendMode.color;
  Matrix4Transform transform = Matrix4Transform();
  Size imageSize;
  BoxFit imageFit = BoxFit.cover;
  double aspectRatio = myAspectRatios[0];
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

  changeAspectRatio() {
    setState(() {
      int indexAspectRatio = myAspectRatios.indexOf(aspectRatio);
      if (indexAspectRatio == myAspectRatios.length - 1)
        indexAspectRatio = 0;
      else
        indexAspectRatio++;
      aspectRatio = myAspectRatios[indexAspectRatio];
    });
  }

  @override
  void initState() {
    _imageMedia = widget.imageMedia;
    // _image = widget.imageMedia.image;
    tabController = TabController(length: 4, vsync: this);
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

    // restore() {
    //   _imageMedia = widget.imageMedia;
    //   setState(() {});
    // }

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

    Future<ImageMedia> getImageMedia() async {
      _imageMedia.image = await _capturePng();
      return _imageMedia;
    }

    resizeImage(Uint8List image) {
      _imageMedia.image = image;
      setState(() {});
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
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

                  navigator.pop(context);
                  widget.onMediaSelected(context, getImageMedia);
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
                Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                AspectRatio(
                  aspectRatio: aspectRatio,
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
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: FittedBox(
                            child: IconButton(
                                icon: Icon(
                                  Icons.settings_overscan,
                                ),
                                onPressed: changeFit),
                          ),
                        ),
                        Expanded(
                          child: FittedBox(
                            child: IconButton(
                                icon: Icon(
                                  Icons.content_cut,
                                ),
                                onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => ResizeImageDialog(
                                          image: _imageMedia.image,
                                          aspectRatio: aspectRatio,
                                          changeAspectRatio: changeAspectRatio,
                                          resizeImage: resizeImage),
                                    )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FittedBox(
                            child: IconButton(
                                icon: Icon(
                                  Icons.flip,
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
                                ),
                                onPressed: () => rotate(90)),
                          ),
                        ),
                        Expanded(
                          child: FittedBox(
                            child: IconButton(
                                icon: Icon(
                                  Icons.rotate_left,
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
                        IconButton(
                          iconSize: 50,
                          icon: Icon(Icons.clear),
                          onPressed: colorFilter != null
                              ? () {
                                  colorFilter = null;
                                  setState(() {});
                                }
                              : null,
                        ),
                        // GestureDetector(
                        //   child: Container(
                        //     height: 50,
                        //     decoration: BoxDecoration(
                        //         border: Border.all(width: 1),
                        //         shape: BoxShape.circle),
                        //     child: FittedBox(child: ),
                        //   ),
                        //   onTap: colorFilter != null
                        //       ? () {
                        //           colorFilter = null;
                        //           setState(() {});
                        //         }
                        //       : null,
                        // ),
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
                                              : Theme.of(context)
                                                  .unselectedWidgetColor))))
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
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
                                    shape: BoxShape.circle),
                                child: FittedBox(
                                    child: Icon(Icons.remove,
                                        color:
                                            Theme.of(context).backgroundColor)),
                              )
                            : Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    border: colorFilter == Colors.white ||
                                            colorFilter == Colors.black
                                        ? Border.all(
                                            width: 1,
                                            color: Theme.of(context)
                                                .unselectedWidgetColor)
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
          indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 0)),
          controller: tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.settings_overscan),
            ),
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

class ResizeImageDialog extends StatefulWidget {
  ResizeImageDialog(
      {@required this.resizeImage,
      @required this.image,
      @required this.aspectRatio,
      @required this.changeAspectRatio});
  Function resizeImage;
  Uint8List image;
  double aspectRatio;
  Function changeAspectRatio;

  @override
  _ResizeImageDialogState createState() => _ResizeImageDialogState();
}

class _ResizeImageDialogState extends State<ResizeImageDialog> {
  ImageProvider provider;

  GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  Future<Uint8List> save() async {
    final ExtendedImageEditorState state = editorKey.currentState;
    final Rect rect = state.getCropRect();
    final Uint8List img = state.rawImageData;

    final ImageEditorOption option = ImageEditorOption();

    option.addOption(ClipOption.fromRect(rect));

    option.outputFormat = const OutputFormat.png(88);

    final Uint8List result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    return result;
  }

  @override
  void dispose() {
    editorKey.currentState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ExtendedMemoryImageProvider(widget.image);
    return Dialog(
      child: SizedBox(
        height: 500,
        child: Column(
          children: <Widget>[
            Stack(alignment: Alignment.bottomCenter, children: [
              ExtendedImage(
                height: MediaQuery.of(context).size.width,
                image: provider,
                extendedImageEditorKey: editorKey,
                mode: ExtendedImageMode.editor,
                fit: BoxFit.contain,
                initEditorConfigHandler: (ExtendedImageState state) {
                  return EditorConfig(
                    maxScale: 3.0,
                    cropRectPadding: const EdgeInsets.all(8),
                    hitTestSize: 20.0,
                    cropAspectRatio: widget.aspectRatio,
                    initCropRectType: InitCropRectType.layoutRect,
                  );
                },
              ),
              SizedBox(
                width: 50,
                child: RawMaterialButton(
                  onPressed: widget.changeAspectRatio,
                  elevation: 1,
                  fillColor: Colors.white.withOpacity(0.9),
                  child: Icon(
                    Icons.aspect_ratio,
                    color: Colors.black,
                    size: 20,
                  ),
                  shape: CircleBorder(),
                ),
              ),
            ]),
            Expanded(
              child: Row(
                children: <Widget>[
                  IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.done),
                    onPressed: () async {
                      widget.resizeImage(await save());
                      navigator.pop(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
