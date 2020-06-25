import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  String url;
   UserAvatar({
    @required this.url
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: url!=''? NetworkImage(url):AssetImage('assets/images/user.png'),
    );
  }
}