import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';

class CommentsButton extends StatefulWidget {
  Function refresh;
  Function showTools;
  CommentsButton({this.refresh,this.showTools});
  @override
  _CommentsButtonState createState() => _CommentsButtonState();
}

class _CommentsButtonState extends State<CommentsButton> {
  IconData _icon;
  bool _isShowedComments;

  @override
  Widget build(BuildContext context) {
    _isShowedComments = configuration.getIsShowedComments();
    print(_isShowedComments);
    _icon = _isShowedComments?Icons.comment:Icons.mode_comment;
    return FloatingActionButton(
      onPressed: (){
        configuration.setIsShowedComments(!_isShowedComments);
        widget.showTools();
        widget.refresh();
      },
      backgroundColor: Colors.deepOrange,
      child: Icon(_icon),
    );
  }
}
