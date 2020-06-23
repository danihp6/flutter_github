import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Widgets/post_description.dart';
import 'package:meme/Widgets/post_header.dart';

class PostWidget extends StatelessWidget {
  Post post;
  PostList postList;
  bool activeAlwaysShowedComments;
  PostWidget({@required this.post,this.postList,this.activeAlwaysShowedComments=false});

  @override
  Widget build(BuildContext context) {
    bool _isShowedComments = configuration.getIsShowedComments();

    return Container(
      child: Column(children: [
        if(_isShowedComments || activeAlwaysShowedComments)
        Padding(
          padding: const EdgeInsets.only(left:8),
          child: SizedBox(height: 50,
            child: PostHeader(post: post,postList: postList,)),
        ),
        Image.network(
          post.getMedia(),
          fit: BoxFit.contain,
        ),
        if (_isShowedComments || activeAlwaysShowedComments)
          Padding(
            padding: const EdgeInsets.only(right: 15,left:15,top: 10),
            child: PostDescription(post: post),
          )
      ]),
    );
  }
}

