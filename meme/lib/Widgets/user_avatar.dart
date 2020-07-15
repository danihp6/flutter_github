import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'loading.dart';

class UserAvatar extends StatelessWidget {
  User user;
  bool linked;
  UserAvatar({@required this.user, this.linked = true});

  @override
  Widget build(BuildContext context) {
    if (user.avatar == '')
      return SizedBox(width: 30, child: Image.asset('assets/images/user.png'));

    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100)),
              child: CachedNetworkImage(
          imageUrl: user.avatar,
          placeholder: (context, url) => Loading(),
          errorWidget: (context, url, error) => Container(),
        ),
      ),
      onTap: () => linked
          ? Navigator.push(
              context, SlideLeftRoute(page: UserPage(userId: user.id)))
          : null,
    );
  }
}
