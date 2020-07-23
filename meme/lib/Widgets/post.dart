import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/Template.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post_description.dart';
import 'package:meme/Widgets/post_header.dart';import 'package:meme/Widgets/video_player.dart';
import '../Controller/db.dart';

class PostWidget extends StatefulWidget {
  Post post;
  PostList postList;
  bool isDescriptionShowed;
  GlobalKey<ScaffoldState> scaffoldState;
  PostWidget(
      {@required this.post,
      this.postList,
      this.isDescriptionShowed = true,
      this.scaffoldState});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    List<String> favourites = widget.post.favourites;

    addOrRemoveFavourite(String userId, String postAuthorId, String postId) {
      print(favourites.contains(db.userId));
      if (!favourites.contains(db.userId))
        db.addPostPathInFavourites(userId, postAuthorId, postId);
      else
        db.deletePostPathInFavourites(userId, postAuthorId, postId);
    }

    return StreamBuilder(
        stream: db.getUser(widget.post.author),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return Loading();
          User author = snapshot.data;
          return Column(children: [
            if (widget.isDescriptionShowed)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SizedBox(
                    height: 50,
                    child: PostHeader(
                        post: widget.post,
                        postList: widget.postList,
                        author: author,
                        scaffoldState: widget.scaffoldState)),
              ),
            AspectRatio(
              aspectRatio: widget.post.aspectRatio,
              child: widget.post.mediaType == MediaType.image
                  ? GestureDetector(
                      child: CachedNetworkImage(
                        imageUrl: widget.post.media,
                        placeholder: (context, url) => Loading(),
                      ),
                      onDoubleTap: () => addOrRemoveFavourite(
                          db.userId, widget.post.author, widget.post.id))
                  : VideoPlayerWidget(
                      url: widget.post.media,
                      aspectRatio: widget.post.aspectRatio,
                    ),
            ),
            if (widget.isDescriptionShowed)
              PostDescription(post: widget.post, author: author),
            SizedBox(
              height: 5,
            )
          ]);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
