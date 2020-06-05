import 'package:flutter/material.dart';
import 'package:meme/Models/User.dart';

class FavouriteHeader extends StatelessWidget {
  User user;
  FavouriteHeader({
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.getImage()),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 70,
              child: RaisedButton(
                onPressed: () {},
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
                  Column(
                    children: [
                      Text('Seguidores'),
                      Text(
                        user.getFollowers().toString(),
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text('Seguidos'),
                      Text(
                        user.getFollowed().toString(),
                        style: TextStyle(fontSize: 20),
                      )
                    ],
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
                  user.getName(),
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
    );
  }
}
