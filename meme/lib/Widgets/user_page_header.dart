import 'package:flutter/material.dart';
import 'package:meme/Controller/auth.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/edit_profile_page.dart';
import 'package:meme/Pages/followed_list_page.dart';
import 'package:meme/Pages/followers_list_page.dart';
import 'package:meme/Widgets/edit_profile_button.dart';
import 'package:meme/Widgets/follow_button.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_avatar.dart';

class UserPageHeader extends StatelessWidget {
  User user;
  Function refresh;
  UserPageHeader({@required this.user, this.refresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(
                height: 65,
                width: 65,
                child: UserAvatar(url: user.getAvatar())),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 100,
                child: user.getId()==db.userId? EditProfileButton(user: user,):FollowButton(userId: user.getId()),
              )
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Column(
                        children: [
                          Text('Seguidores'),
                          Text(
                            user.getFollowers().length.toString(),
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      onTap: () => Navigator.push(
                          context,
                          SlideLeftRoute(
                              page: FollowersListPage(userId: user.getId()))),
                    ),
                    GestureDetector(
                      child: Column(
                        children: [
                          Text('Seguidos'),
                          Text(
                            user.getFollowed().length.toString(),
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      onTap: () => Navigator.push(
                          context,
                          SlideLeftRoute(
                              page: FollowedListPage(userId: user.getId()))),
                    ),
                    IconButton(
                        icon: Icon(Icons.settings),
                        iconSize: 30,
                        onPressed: () {
                          auth.signOut().then((_) => refresh());
                        })
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    user.getDescription(),
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

