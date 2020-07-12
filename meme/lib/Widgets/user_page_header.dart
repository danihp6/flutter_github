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
import '../Models/Report.dart';

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
                    : FollowButton(userId: user.id),
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
                    user.id == db.userId
                        ? IconButton(
                            icon: Icon(Icons.menu),
                            iconSize: 30,
                            onPressed: () {
                              scaffoldState.currentState.openEndDrawer();
                            })
                        : IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Container(
                                    height: 200,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FlatButton(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.report,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  'Denunciar',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      ReportModalBottomSheet());
                                            },
                                          )
                                        ]),
                                  ),
                                ),
                              );
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

class ReportModalBottomSheet extends StatelessWidget {
  const ReportModalBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Padding(
        padding:
            const EdgeInsets
                .all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'Motivo',
              style: TextStyle(
                  fontSize:
                      16,
                  color: Colors
                      .white),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: mainReasons.length,
                separatorBuilder: (context, index) => ,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
