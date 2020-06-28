import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
import '../Controller/db.dart';

class LikeCommentButton extends StatefulWidget {
  Comment comment;
  
  LikeCommentButton({@required this.comment});

  @override
  _LikeCommentButtonState createState() => _LikeCommentButtonState();
}

class _LikeCommentButtonState extends State<LikeCommentButton> {
  @override
  Widget build(BuildContext context) {
    List<String> likes = widget.comment.likes;
    if (likes.contains(db.userId))
      return IconButton(
          icon: Icon(Icons.favorite),
          iconSize: 30,
          onPressed: () {
            setState(() {
              db.unlikeComment();
            });
          });

    return IconButton(
        icon: Icon(Icons.favorite_border),
        iconSize: 30,
        onPressed: () {
          setState(() {
            db.addcommentPathInFavourites(
                db.userId, 'users/${widget.comment.authorId}/comments/${widget.post.id}');
          });
        });
  }
}
