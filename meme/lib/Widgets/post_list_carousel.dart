import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/media_storage.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Pages/post_list_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post_list_more_button.dart';
import 'package:meme/Widgets/posts_carousel.dart';
import 'package:rxdart/streams.dart';

import '../Models/PostList.dart';
import 'slide_left_route.dart';

class PostListCarousel extends StatefulWidget {
  PostList postList;
  bool activeMoreOptions;
  Function(BuildContext context, String postListId, String authorId) onTapPostList;
  Function(BuildContext context, Post post) onTapPost;

  PostListCarousel(
      {@required this.postList,
      this.onTapPostList,
      this.onTapPost,
      this.activeMoreOptions = true});

  @override
  _PostListCarouselState createState() => _PostListCarouselState();
}

class _PostListCarouselState extends State<PostListCarousel> {
  @override
  Widget build(BuildContext context) {
    PostList _postList = widget.postList;
    List<String> posts = _postList.posts;
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Row(
            children: [
              if (_postList.image != '') //
                Container(
                  height: 60,
                  width: 60,
                  color: Colors.grey[300],
                  child: CachedNetworkImage(imageUrl: _postList.image),
                ),
              if (_postList.image != '')
                SizedBox(
                  width: 10,
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _postList.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    _postList.posts.length.toString() + ' publicaciones',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              widget.activeMoreOptions
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 30,
                          child: PostListMoreButton(postList: _postList),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          onTap: () => widget.onTapPostList(context,_postList.id,_postList.author),
        ),
        SizedBox(
          height: 5,
        ),
        if (posts.length > 0)
          StreamBuilder(
              stream: db.getPostListGroupPost(widget.postList.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                List<Post> posts = snapshot.data;
                return PostsCarousel(
                  posts: posts,
                  onTap: widget.onTapPost,
                );
              })
      ],
    );
  }
}
