import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/navigator.dart';
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
          title: Text('Seguidores'),
        ),
        body: StreamBuilder(
            stream: db.getUser(db.userId),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return Loading();
              User currentUser = snapshot.data;
              List<String> yourBlockedUsers = currentUser.blockedUsers;
              return StreamBuilder(
                  stream: db.getUser(userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return Loading();
                    User user = snapshot.data;
                    List<String> followers = user.followers;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: followers.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream: db.getUser(followers[index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              if (!snapshot.hasData) return Loading();
                              User followerUser = snapshot.data;
                              bool blocked =
                                  yourBlockedUsers.contains(followerUser.id);
                              List<String> blockedUsers =
                                  followerUser.blockedUsers;
                              bool youAreBlocked =
                                  blockedUsers.contains(db.userId);
                              return UserRow(
                                user: followerUser,
                                blocked: blocked,
                                youAreBlocked: youAreBlocked,
                                onTap: () => navigator.goUser(context, userId),
                              );
                            },
                          );
                        },
                      ),
                    );
                  });
            }));
  }
}
