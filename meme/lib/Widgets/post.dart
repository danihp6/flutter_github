import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post_description.dart';
import 'package:meme/Widgets/post_header.dart';
import 'package:meme/Widgets/video_player.dart';
import '../Controller/db.dart';

class PostWidget extends StatefulWidget {
  Post post;
  PostList postList;
  bool activeAlwaysShowedComments;
  PostWidget(
      {@required this.post,
      this.postList,
      this.activeAlwaysShowedComments = false});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    bool _isShowedComments = configuration.getIsShowedComments();
    List<String> favourites = widget.post.favourites;

    addOrRemoveFavourite(String userId, String postId) {
      String postPath = 'users/${widget.post.authorId}/posts/${widget.post.id}';
      print(favourites.contains(db.userId));
      if (!favourites.contains(db.userId))
        db.addPostPathInFavourites(userId, postPath);
      else
        db.deletePostPathInFavourites(userId, postPath);
    }

    return StreamBuilder(
        stream: db.getUser(widget.post.authorId),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return Loading();
          User author = snapshot.data;
          return Column(children: [
            if (_isShowedComments || widget.activeAlwaysShowedComments)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SizedBox(
                    height: 50,
                    child: PostHeader(
                      post: widget.post,
                      postList: widget.postList,
                      author: author,
                    )),
              ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: widget.post.mediaType == 'image'
                      ? GestureDetector(
                          child: Image.network(
                            widget.post.media,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print(error);
                              return Container();
                            },
                          ),
                          onDoubleTap: () => addOrRemoveFavourite(db.userId,
                              'users/${widget.post.authorId}/posts/${widget.post.id}'))
                      : VideoPlayerWidget(url: widget.post.media),
                ),
              ],
            ),
            if (_isShowedComments || widget.activeAlwaysShowedComments)
              PostDescription(post: widget.post, author: author)
          ]);
        });
  }
}
