import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';

class Stream2Users extends StatelessWidget {
  Stream2Users(
      {@required this.userId,
      @required this.scaffoldState,
      @required this.childCurrentUser,
      @required this.childNotCurrentUser});
  String userId;
  GlobalKey<ScaffoldState> scaffoldState;
  Widget Function(User currentUser, GlobalKey<ScaffoldState> scaffoldState)
      childCurrentUser;
  Widget Function(User user, GlobalKey<ScaffoldState> scaffoldState,
      bool blocked, bool youAreBlocked) childNotCurrentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db.getUser(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return Loading();
          User user = snapshot.data;
          List<String> blockedUsers = user.blockedUsers;
          bool youAreBlocked = blockedUsers.contains(db.userId);
          if (userId != db.userId)
            return StreamBuilder(
                stream: db.getUser(db.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return Loading();
                  User currentUser = snapshot.data;
                  List<String> yourBlockedUsers = currentUser.blockedUsers;
                  bool blocked = yourBlockedUsers.contains(user.id);


                  return childNotCurrentUser(
                      user, scaffoldState, blocked, youAreBlocked);
                });
          return childCurrentUser(user, scaffoldState);
        });
  }
}
