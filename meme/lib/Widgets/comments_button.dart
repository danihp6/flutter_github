import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';

class CommentsButton extends StatefulWidget {
  Function refresh;
  CommentsButton({@required this.refresh});
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
    return IconButton(
      onPressed: (){
        configuration.setIsShowedComments(!_isShowedComments);
        widget.refresh();
      },
      icon: Icon(_icon),
    );
  }
}
