import 'package:flutter/material.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/follow_button.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_avatar.dart';

class UserRow extends StatelessWidget {
  User user;
  Function onTap;
  UserRow({
    @required this.user,
    @required this.onTap
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
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          onTap: onTap,
        ),
        FollowButton(userId: user.id)
      ],
    );
  }
}
