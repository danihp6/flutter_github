import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/User.dart';

import 'loading.dart';

class UserAvatar extends StatelessWidget {
  User user;
  bool linked;
  UserAvatar({@required this.user, this.linked = true});

  @override
  Widget build(BuildContext context) {
    if (user.avatar == '')
      return Image.asset('assets/images/user.png');

    

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
          ? navigator.goUser(context,user.id)
          : null,
    );
  }
}
