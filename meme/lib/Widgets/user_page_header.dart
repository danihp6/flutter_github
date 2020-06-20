import 'package:flutter/material.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/edit_profile_page.dart';
import 'package:meme/Pages/user_list_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class UserPageHeader extends StatelessWidget {
  User user;
  UserPageHeader({
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.getAvatar()),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 70,
                child: RaisedButton(
                  onPressed: () =>Navigator.push(context, SlideLeftRoute(page:EditProfilePage(user:user))),
                  color: Colors.deepOrange,
                  textColor: Colors.white,
                  child: Text('Editar'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
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
                      onTap: () => Navigator.push(context, SlideLeftRoute(page: UserListPage(title: 'Seguidores', userListId: user.getFollowers()))),
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
                      onTap: () => Navigator.push(context, SlideLeftRoute(page: UserListPage(title: 'Seguidos', userListId: user.getFollowed()))),
                    ),
                    IconButton(
                        icon: Icon(Icons.settings),
                        iconSize: 30,
                        onPressed: () {})
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    user.getUserName(),
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
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
