import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/media_storage.dart';
import 'package:meme/Pages/post_list_page.dart';
import 'package:meme/Widgets/posts_carousel.dart';

import '../Models/PostList.dart';
import 'slide_left_route.dart';

class PostListCarousel extends StatefulWidget {
  PostList postList;
  bool activeMoreOptions;
  Function onTapPostList;
  Function onTapPost;

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _postList.name,
                    style: TextStyle(fontSize: 18),
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
                          child: PopupMenuButton(
                            child: Icon(Icons.more_vert),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delete),
                                      Text('Eliminar categoria')
                                    ],
                                  ),
                                  value: () {
                                    if (_postList.imageLocation != '')
                                      mediaStorage
                                          .deleteFile(_postList.imageLocation);
                                    db.deletePostList(db.userId, _postList.id);
                                  },
                                )
                              ];
                            },
                            onSelected: (function) => function(),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          onTap: () => widget.onTapPostList(_postList),
        ),
        SizedBox(
          height: 5,
        ),
        if (posts.length > 0)
          PostsCarousel(
            posts: posts,
            onTap: widget.onTapPost,
          )
      ],
    );
  }
}
