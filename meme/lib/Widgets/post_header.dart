import 'package:flutter/material.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/post_menu.dart';
import 'package:meme/Widgets/share_button.dart';
import 'package:meme/Widgets/user_avatar.dart';

class PostHeader extends StatelessWidget {
  Post post;
  PostList postList;
  User author;
  PostHeader({@required this.post, this.postList, @required this.author});

  PersistentBottomSheetController bottomSheetController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatar(user: author),
        SizedBox(width: 10),
        Text(
          author.userName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShareButton(),
              SizedBox(
                width: 35,
                child: PostMenu(
                  post: post,
                  postList: postList,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}


