import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/Template.dart';
import 'package:meme/Widgets/scroll_column_expandable.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Controller/gallery.dart';
import '../Widgets/floating_text.dart';

class TemplateText extends StatefulWidget {
  Template template;
  TemplateText({@required this.template});

  @override
  _TemplateTextState createState() => _TemplateTextState();
}

class _TemplateTextState extends State<TemplateText>
    with SingleTickerProviderStateMixin {
  Size imageSize;
  Color textColor = Colors.white;
  double textSize = 30.0;
  GlobalKey _globalKey = new GlobalKey();
  Uint8List result;
  bool isTextOptionsVisible = true;

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

  showTextOptions() {
    setState(() {
      isTextOptionsVisible = !isTextOptionsVisible;
      print(isTextOptionsVisible);
    });
  }

  Future<ImageMedia> getImageMedia() async {
    Uint8List image = await _capturePng();
    return ImageMedia(image, 1);
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () async {
                  isTextOptionsVisible = false;
                  setState(() {});
                  await Future.delayed(const Duration(milliseconds: 10), () {});
                  
                  navigator.pop(context);
                  navigator.goUploadPublication(
                      context, getImageMedia, widget.template);
                })
          ],
        ),
      ),
      body: ScrollColumnExpandable(
        children: <Widget>[
          RepaintBoundary(
            key: _globalKey,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                      imageUrl: widget.template.image,
                      placeholder: (context, url) =>
                          Image.memory(kTransparentImage),
                      fit: BoxFit.cover),
                ),
                FloatingText(
                  isTextOptionsVisible: isTextOptionsVisible,
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
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
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
