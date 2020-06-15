import 'package:flutter/material.dart';
import 'package:meme/Pages/select_image_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import '../Controller/Configuration.dart';

class FloatingButtons extends StatefulWidget {
  Function refresh;
  FloatingButtons({this.refresh});
  @override
  _FloatingButtonsState createState() => _FloatingButtonsState();
}

class _FloatingButtonsState extends State<FloatingButtons> {
  bool _isShowedTools, _isOpenTools = false, _isOpenPublicationOptions = false;
  List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    _isShowedTools = configuration.getIsShowedTools();

    return _isShowedTools
        ? Dismissible(
            key: Key('hideTool'),
            direction: DismissDirection.startToEnd,
            confirmDismiss: (direction) async {
              configuration.setIsShowedTools(false);
              setState(() {});
              return false;
            },
            child: FloatingActionButton(
              heroTag: 'tools',
              onPressed: ()=>Navigator.push(context, SlideLeftRoute(page:SelectImagePage())),
              backgroundColor: Colors.deepOrange,
              child: Icon(
                Icons.file_upload,
                size: 35,
              ),
            ),
          )
        : Dismissible(
            key: Key('showTool'),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              configuration.setIsShowedTools(true);
              setState(() {});
              return false;
            },
            child: Opacity(
              opacity: 0.5,
              child: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: Colors.deepOrange,
                ),
            ),
          );
  }
}
