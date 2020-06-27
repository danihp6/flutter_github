import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';

class FollowButton extends StatefulWidget {
  String userId;
  FollowButton({@required this.userId});
  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  String _lookedUserId;
  @override
  Widget build(BuildContext context) {
    _lookedUserId = widget.userId;
    return StreamBuilder(
        stream: db.getUser(db.userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return Loading();
          User user = snapshot.data;
          bool userFollowed = user.followed.contains(_lookedUserId);
          return RaisedButton(
            onPressed: () => userFollowed
                ? db.unfollow(user.id, _lookedUserId)
                : db.follow(user.id, _lookedUserId),
            child: Text(userFollowed ? 'Siguiendo' : 'Seguir'),
            color: userFollowed?Colors.orange:Colors.blue,
            textColor: Colors.white,
          );
        });
  }
}
