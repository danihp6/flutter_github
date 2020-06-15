import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';

class IconButtonComments extends StatelessWidget {
  Function refresh;
  IconButtonComments({@required this.refresh});
  bool _isShowedComments = configuration.getIsShowedComments();
  IconData _icon;
  @override
  Widget build(BuildContext context) {
    _icon = _isShowedComments?Icons.comment:Icons.mode_comment;
    return IconButton(
      icon: Icon(_icon), 
      onPressed: (){
        configuration.setIsShowedComments(!_isShowedComments);
        refresh();
      }
      );
  }
}