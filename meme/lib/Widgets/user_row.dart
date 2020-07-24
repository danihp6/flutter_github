import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/follow_button.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_avatar.dart';

class UserRow extends StatelessWidget {
  User user;
  Function onTap;
  bool blocked;
  bool youAreBlocked;
  UserRow({
    @required this.user,
    @required this.onTap,
    @required this.blocked,
    @required this.youAreBlocked
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          child: Row(
            children: [
              UserAvatar(user: user),
              SizedBox(
                width: 10,
              ),
              Text(
                user.userName,
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          onTap: onTap,
        ),
        if(!blocked && !youAreBlocked)
        FollowButton(user: user)
        else UnblockButton(user:user)
      ],
    );
  }
}

class UnblockButton extends StatelessWidget {
  User user;
   UnblockButton({@required this.user});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => db.unblock(db.userId, user.id),
      child: Text('Bloqueado'),
      color: Colors.red,
      textColor: Colors.white,
    );
  }
}
