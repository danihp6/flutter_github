import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class UserAvatar extends StatelessWidget {
  User user;
  bool linked;
   UserAvatar({
    @required this.user,this.linked = true
  });

  @override
  Widget build(BuildContext context) {

    ImageProvider image(){
      if(user.avatar=='') return AssetImage('assets/images/user.png');
      return NetworkImage(user.avatar);
    }

    return GestureDetector(
          child: CircleAvatar(
        backgroundImage: image(),
      ),
      onTap: ()=>linked?Navigator.push(context, SlideLeftRoute(page: UserPage(userId:user.id))):null,
    );
  }
}