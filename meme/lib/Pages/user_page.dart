import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/user_page_body.dart';
import 'package:meme/Widgets/user_page_header.dart';

class UserPage extends StatelessWidget {
  String userId;
  UserPage({@required this.userId});
  @override


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: StreamBuilder(
              stream: getUser(userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return CircularProgressIndicator();
                User user = snapshot.data;
                print(user);
                return Column(
                  children: [
                    UserPageHeader(user: user),
                    Expanded(child: UserPageBody(user: user)),
                  ],
                );
              }),
        ),
      ),
    );
  }
}