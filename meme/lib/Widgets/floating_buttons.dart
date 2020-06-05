import 'package:flutter/material.dart';
import 'package:meme/Widgets/comments_button.dart';

class FloatingButtons extends StatefulWidget {
  Function refresh;
  FloatingButtons({this.refresh});
  @override
  _FloatingButtonsState createState() => _FloatingButtonsState();
}

class _FloatingButtonsState extends State<FloatingButtons> {
  bool _isShowedTools = false;
  @override
  Widget build(BuildContext context) {
    Function showTools() {
      setState(() {
        _isShowedTools = !_isShowedTools;
      });
    }

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      _isShowedTools
          ? Container(
              height: 45,
              child: FloatingActionButton(
                onPressed: null,
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
