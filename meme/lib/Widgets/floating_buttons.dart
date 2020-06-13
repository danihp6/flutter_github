import 'package:flutter/material.dart';
import 'package:meme/Pages/publication_upload_page.dart';
import 'package:meme/Widgets/comments_button.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import '../Controller/Configuration.dart';

class FloatingButtons extends StatefulWidget {
  Function refresh;
  FloatingButtons({this.refresh});
  @override
  _FloatingButtonsState createState() => _FloatingButtonsState();
}

class _FloatingButtonsState extends State<FloatingButtons> {
  bool _isShowedTools;
  @override
  Widget build(BuildContext context) {
    _isShowedTools = configuration.getIsShowedTools();

    Function showTools() {
      configuration.setIsShowedTools(!_isShowedTools);
      setState(() {});
    }

    Function goPublicationUploadPage(){
      showTools();
      Navigator.push(context, SlideLeftRoute(page: PublicationUploadPage(userId: configuration.getUserId(),)));
    }

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      _isShowedTools
          ? Container(
              height: 45,
              child: FloatingActionButton(
                onPressed: goPublicationUploadPage,
                backgroundColor: Colors.deepOrange,
                child: Icon(Icons.file_upload),
              ))
          : SizedBox(),
      SizedBox(height: 5),
      _isShowedTools
          ? Container(height: 45, child: CommentsButton(refresh:widget.refresh,showTools:showTools))
          : SizedBox(),
      SizedBox(height: 5),
      FloatingActionButton(
        heroTag: 'newPublications',
        onPressed: showTools,
        backgroundColor: Colors.deepOrange,
        child: Icon(
          Icons.build,
          size: 35,
        ),
      )
    ]);
  }
}
