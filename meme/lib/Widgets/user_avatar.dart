import 'dart:io';

import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  String url;
  File file;
   UserAvatar({
    this.url='',this.file
  });

  @override
  Widget build(BuildContext context) {

    ImageProvider image(){
      if(url=='' && file == null ) return AssetImage('assets/images/user.png');
      if(file != null) return FileImage(file);
      return NetworkImage(url);
    }

    return CircleAvatar(
      backgroundImage: image(),
    );
  }
}