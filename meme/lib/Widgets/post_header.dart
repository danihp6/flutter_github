import 'package:flutter/material.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'post_more_button.dart';
import 'package:meme/Widgets/share_button.dart';
import 'package:meme/Widgets/user_avatar.dart';

class PostHeader extends StatelessWidget {
  Post post;
  PostList postList;
  User author;
  GlobalKey<ScaffoldState> scaffoldState;
  PostHeader(
      {@required this.post,
      this.postList,
      @required this.author,
      @required this.scaffoldState});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(height: 40, child: UserAvatar(user: author)),
        SizedBox(width: 10),
        Text(
          author.userName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShareButton(
                  authorId: post.author,
                  postId: post.id,
                  scaffoldState: scaffoldState),
              SizedBox(
                width: 35,
                child: PostMoreButton(
                  post: post,
                  postList: postList,
                  scaffoldState: scaffoldState,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
