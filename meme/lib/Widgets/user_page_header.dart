import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/navigator.dart';
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
                if(user.description != '')
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(user.description,
                      maxLines: 3,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 14)),
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
        Row(
          children: <Widget>[
            // Text('Reputación',style:Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14)),
            Text(user.totalPoints.toString(),
                style: Theme.of(context).textTheme.bodyText1),
                SizedBox(width:2),
            Icon(Icons.whatshot)
          ],
        ),
        GestureDetector(
          child: Column(
            children: [
              Text('Seguidores',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 14)),
              Text(user.followers.length.toString(),
                  style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
          onTap: () => navigator.goFollowers(context, user.id),
        ),
        GestureDetector(
          child: Column(
            children: [
              Text('Seguidos',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 14)),
              Text(user.followed.length.toString(),
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
          onTap: () => Navigator.push(
              context, SlideLeftRoute(page: FollowedListPage(userId: user.id))),
        ),
      ],
    );
  }
}
