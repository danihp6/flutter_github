import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Widgets/post_description.dart';
import 'package:meme/Widgets/post_header.dart';
import 'package:meme/Widgets/video_player.dart';
import '../Controller/db.dart';

class PostWidget extends StatelessWidget {
  Post post;
  PostList postList;
  bool activeAlwaysShowedComments;
  PostWidget(
      {@required this.post,
      this.postList,
      this.activeAlwaysShowedComments = false});

  @override
  Widget build(BuildContext context) {
    bool _isShowedComments = configuration.getIsShowedComments();
    List<String> favourites = post.favourites;

    addOrRemoveFavourite(String userId,String postId){
      String postPath = 'users/${post.authorId}/posts/${post.id}';
      print(favourites.contains(db.userId));
      if(!favourites.contains(db.userId)) db.addPostPathInFavourites(userId, postPath);
      else db.deletePostPathInFavourites(userId, postPath);

    }

    return Container(
      child: Column(children: [
        if (_isShowedComments || activeAlwaysShowedComments)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SizedBox(
                height: 50,
                child: PostHeader(
                  post: post,
                  postList: postList,
                )),
          ),
        GestureDetector(
                  child: AspectRatio(
            aspectRatio: 1,
                    child: post.mediaType == 'image'
                ? Image.network(
                    post.media,
                    fit: BoxFit.contain,
                  )
                : VideoPlayerWidget(url: post.media),
          ),
          onDoubleTap: ()=> addOrRemoveFavourite(db.userId, 'users/${post.authorId}/posts/${post.id}')
        ),
        if (_isShowedComments || activeAlwaysShowedComments)
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
            child: PostDescription(post: post),
          )
      ]),
    );
  }
}
