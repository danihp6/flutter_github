import 'package:flutter/material.dart';
import 'package:meme/Models/Post.dart';

import '../Controller/db.dart';

class FavouriteButton extends StatefulWidget {
  Post post;
  FavouriteButton({@required this.post});

  @override
  _FavouriteButtonState createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    List<String> favourites = widget.post.favourites;
    if (favourites.contains(db.userId))
      return IconButton(
          icon: Icon(Icons.star),
          iconSize: 35,
          onPressed: () {
            setState(() {
              db.deletePostPathInFavourites(
                  db.userId, widget.post.author,widget.post.id);
            });
          });

    return IconButton(
        icon: Icon(Icons.star_border),
        iconSize: 35,
        onPressed: () {
          setState(() {
            db.addPostPathInFavourites(
                db.userId, widget.post.author,widget.post.id);
          });
        });
  }
}
