import 'package:flutter/material.dart';
import 'package:meme/Pages/publication_upload_page.dart';
import 'package:meme/Widgets/comments_button.dart';
import 'package:meme/Widgets/gallery_publication_button.dart';
import 'package:meme/Widgets/new_publication_button.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import '../Controller/Configuration.dart';

class FloatingButtons extends StatefulWidget {
  Function refresh;
  FloatingButtons({this.refresh});
  @override
  _FloatingButtonsState createState() => _FloatingButtonsState();
}

class _FloatingButtonsState extends State<FloatingButtons> {
  bool _isShowedTools,_isOpenTools=false,_isOpenPublicationOptions = false;
  @override
  Widget build(BuildContext context) {
    _isShowedTools = configuration.getIsShowedTools();

    Function openTools() {
      if(_isOpenTools){
        _isOpenTools = false;
        _isOpenPublicationOptions = false;
      } else _isOpenTools = true;
      setState(() {});
    }

    Function openPublicationOptions() {
      setState(() {
        _isOpenPublicationOptions = !_isOpenPublicationOptions;
      });
    }

    return _isShowedTools?Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      _isOpenTools
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _isOpenPublicationOptions?Container(
                    height: 45,
                    child: GalleryPublicationButton()):Container(),
                Container(
                    height: 45,
                    child: NewPublicationButton(openPublicationOptions: openPublicationOptions)),
              ],
            )
          : SizedBox(),
      SizedBox(height: 5),
      _isOpenTools
          ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  height: 45,
                  child:
                      CommentsButton(refresh: widget.refresh, openTools: openTools)),
            ],
          )
          : SizedBox(),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'tools',
            onPressed: openTools,
            backgroundColor: Colors.deepOrange,
            child: Icon(
              Icons.build,
              size: 35,
            ),
          ),
        ],
      )
    ]):Container();
  }
}
