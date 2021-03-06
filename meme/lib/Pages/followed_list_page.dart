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

class FollowedListPage extends StatelessWidget {
  String userId;
  FollowedListPage({@required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Seguidos'),
        ),
        body: StreamBuilder(
            stream: db.getUser(userId),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return Loading();
              User user = snapshot.data;
              List<String> followed = user.followed;
              if(followed.isNotEmpty)
              return StreamBuilder(
                  stream: db.getUser(db.userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return Loading();
                    User currentUser = snapshot.data;
                    List<String> yourBlockedUsers = currentUser.blockedUsers;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        itemCount: followed.length,
                        separatorBuilder: (context, index) => SizedBox(height: 5,),
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream: db.getUser(followed[index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              if (!snapshot.hasData) return Loading();
                              User followedUser = snapshot.data;
                              bool blocked =
                                  yourBlockedUsers.contains(followedUser.id);
                              List<String> blockedUsers =
                                  followedUser.blockedUsers;
                              bool youAreBlocked =
                                  blockedUsers.contains(db.userId);
                              return SizedBox(
                                height: 40,
                                child: UserRow(
                                    user: followedUser,
                                    blocked: blocked,
                                    youAreBlocked: youAreBlocked,
                                    onTap: () => navigator.goUser(
                                        context, followedUser.id)),
                              );
                            },
                          );
                        },
                      ),
                    );
                  });
                return Center(child: Text('${user.userName} no sigue a ningun usuario',style: Theme.of(context).textTheme.bodyText1,));
            }));
  }
}
