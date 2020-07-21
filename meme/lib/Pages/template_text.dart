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
import 'package:meme/Models/Template.dart';
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
                  Uint8List image = await _capturePng();
                  navigator.pop(context);
                  navigator.goUploadPublication(context, ImageMedia(image, 1));

              }
              )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          RepaintBoundary(
            key: _globalKey,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(widget.template.front, fit: BoxFit.cover),
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
