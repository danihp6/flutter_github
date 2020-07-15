import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/followed_list_page.dart';
import 'package:meme/Pages/followers_list_page.dart';
import 'package:meme/Widgets/edit_profile_button.dart';
import 'package:meme/Widgets/follow_button.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_avatar.dart';

class UserPageHeader extends StatelessWidget {
  User user;
  GlobalKey<ScaffoldState> scaffoldState;
  UserPageHeader({@required this.user, this.scaffoldState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(
                  height: 80,
                  width: 80,
                  child: UserAvatar(
                    user: user,
                    linked: false,
                  )),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 100,
                child: user.id == db.userId
                    ? EditProfileButton(
                        user: user,
                      )
                    : FollowButton(
                        user: user,
                      ),
              )
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                UserFollowedPoints(user: user),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    user.description,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UserFollowedPoints extends StatelessWidget {
  const UserFollowedPoints({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: <Widget>[
            Text('Reputación'),
              Text(
                user.getTotalHotPoints().toString(),
                style: TextStyle(fontSize: 20),
              )
          ],
        ),
        GestureDetector(
          child: Column(
            children: [
              Text('Seguidores'),
              Text(
                user.followers.length.toString(),
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          onTap: () => Navigator.push(
              context,
              SlideLeftRoute(
                  page: FollowersListPage(userId: user.id))),
        ),
        GestureDetector(
          child: Column(
            children: [
              Text('Seguidos'),
              Text(
                user.followed.length.toString(),
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          onTap: () => Navigator.push(
              context,
              SlideLeftRoute(
                  page: FollowedListPage(userId: user.id))),
        ),
      ],
    );
  }
}
