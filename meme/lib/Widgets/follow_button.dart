import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';

class FollowButton extends StatelessWidget {
  User user;
  FollowButton({@required this.user});

  @override
  Widget build(BuildContext context) {
    bool userFollowed = user.followed.contains(user.id);
    return RaisedButton(
      onPressed: () => userFollowed
          ? db.unfollow(db.userId, user.id)
          : db.follow(db.userId, user.id),
      child: Text(userFollowed ? 'Siguiendo' : 'Seguir'),
      color: userFollowed ? Colors.blueAccent : Theme.of(context).accentColor,
      textColor: Colors.white,
    );
  }
}
