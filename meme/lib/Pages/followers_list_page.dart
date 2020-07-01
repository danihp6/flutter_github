import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/follow_button.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_avatar.dart';
import 'package:meme/Widgets/user_row.dart';

class FollowersListPage extends StatelessWidget {
  String userId;
  FollowersListPage({@required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Seguidores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: db.getUser(userId),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return Loading();
              User user = snapshot.data;
              List<String> followers = user.followers;
              return ListView.builder(
                itemCount: followers.length,
                itemBuilder: (context, index) {
                  return StreamBuilder(
                    stream: db.getUser(followers[index]),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      if (!snapshot.hasData) return Loading();
                      User followerUser = snapshot.data;
                      return UserRow(
                        user: followerUser,
                        onTap: () => Navigator.push(
                            context,
                            SlideLeftRoute(
                                page: UserPage(
                              userId: user.id,
                            ))),
                      );
                    },
                  );
                },
              );
            }),
      ),
    );
  }
}
