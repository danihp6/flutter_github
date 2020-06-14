import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';

class CommentsButton extends StatefulWidget {
  Function refresh;
  Function openTools;
  CommentsButton({this.refresh,this.openTools});
  @override
  _CommentsButtonState createState() => _CommentsButtonState();
}

class _CommentsButtonState extends State<CommentsButton> {
  IconData _icon;
  bool _isShowedComments;

  @override
  Widget build(BuildContext context) {
    _isShowedComments = configuration.getIsShowedComments();
    _icon = _isShowedComments?Icons.comment:Icons.mode_comment;
    return FloatingActionButton(
      heroTag: 'showComments',
      onPressed: (){
        configuration.setIsShowedComments(!_isShowedComments);
        widget.openTools();
        widget.refresh();
      },
      backgroundColor: Colors.deepOrange,
      child: Icon(_icon),
    );
  }
}
