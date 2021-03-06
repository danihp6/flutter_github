import 'package:flutter/material.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Pages/select_media_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Controller/Configuration.dart';
import 'fading_dismissible.dart';

class UploadButton extends StatefulWidget {
  Function refresh;
  UploadButton({this.refresh});
  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  bool _isShowedTools;

  @override
  Widget build(BuildContext context) {
    _isShowedTools = configuration.getIsShowedTools();

    return _isShowedTools
        ? FadingDismissible(
          key: Key('uploadButton'),
          direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              configuration.setIsShowedTools(false);
              setState(() {});
              return false;
            },
            child: FloatingActionButton(
              heroTag: 'tools',
              onPressed: ()async =>await Permission.storage.request().isGranted?navigator.goSelectMedia(context):null,
              child: Icon(
                Icons.file_upload,
                size: 35,
              ),
            ),
          )
        : Dismissible(
          key: Key('showUploadButton'),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              configuration.setIsShowedTools(true);
              setState(() {});
              return false;
            },
            child: Opacity(
              opacity: 0.4,
              child: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                ),
            ),
          );
  }
}
