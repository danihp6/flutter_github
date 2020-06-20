import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/user_page_body.dart';
import 'package:meme/Widgets/user_page_header.dart';

class UserPage extends StatelessWidget {
  String userId;
  UserPage({@required this.userId});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
            stream: getUser(userId),
            builder: (context, snap) {
              if (snap.hasError) print(snap.error);
              if (!snap.hasData) return CircularProgressIndicator();
              User user = snap.data;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserPageHeader(user: user),
                  Flexible(child: UserPageBody(user: user)),
                ],
              );
            }),
      ),
    );
  }
}
