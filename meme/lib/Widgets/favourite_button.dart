import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
import '../Controller/db.dart';

class FavouriteButton extends StatefulWidget {
  String postId;
  String userId;
  FavouriteButton(
      {@required this.postId, @required this.userId});

  @override
  _PostListButtonState createState() =>
      _PostListButtonState();
}

class _PostListButtonState
    extends State<FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db.getPostFavourites(widget.userId,widget.postId),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return Loading();
          List<String> postList = snapshot.data;
          if (postList
              .contains(db.userId))
            return IconButton(
              icon: Icon(Icons.star),
              iconSize: 30,
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  db.deletePostPathInFavourites(db.userId, 'users/${widget.userId}/posts/${widget.postId}');
                });
              });

          return IconButton(
              icon: Icon(Icons.star_border),
              iconSize: 30,
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  db.addPostPathInFavourites(db.userId, 'users/${widget.userId}/posts/${widget.postId}');
                });
              });
        });
  }
}