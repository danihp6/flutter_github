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
import 'package:meme/Widgets/post_header.dart';
import 'package:meme/Widgets/video_player.dart';
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
  double _opacity = 0;
  @override
  Widget build(BuildContext context) {
    List<String> favourites = widget.post.favourites;

    Future setOpacity() async {
      setState(() {
        _opacity = 1.0;
      });
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        _opacity = 0;
      });
    }

    addOrRemoveFavourite(String userId, String postAuthorId, String postId) {
      print(favourites.contains(db.userId));
      if (!favourites.contains(db.userId)) {
        setOpacity();
        db.addPostInFavourites(userId, postAuthorId, postId);
      } else
        db.deletePostInFavourites(userId, postAuthorId, postId);
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
                      child:
                          Stack(alignment: Alignment.center, children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: widget.post.media,
                          placeholder: (context, url) => Loading(),
                        ),
                        AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: _opacity,
                            child: Icon(
                              Icons.star,
                              color: Colors.black54,
                              size: 250,
                            ))
                      ]),
                      onDoubleTap: () => addOrRemoveFavourite(
                          db.userId, widget.post.author, widget.post.id))
                  : VideoPlayerWidget(
                      url: widget.post.media,
                      aspectRatio: widget.post.aspectRatio,
                    ),
            ),
            if (widget.isDescriptionShowed)
              PostDescription(
                  post: widget.post, author: author, setOpacity: setOpacity),
            SizedBox(
              height: 5,
            )
          ]);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
