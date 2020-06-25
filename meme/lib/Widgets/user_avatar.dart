import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  String url;
   UserAvatar({
    @required this.url
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: url!=''? NetworkImage(url):AssetImage('assets/images/user.png'),
    );
  }
}