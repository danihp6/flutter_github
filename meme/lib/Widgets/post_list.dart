import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Models/PostList.dart';
import 'post_list_more_button.dart';

class PostListWidget extends StatefulWidget {
  PostList postList;
  bool activeMoreOptions;
  Function onTap;

  PostListWidget(
      {@required this.postList,
      @required this.onTap,
      this.activeMoreOptions = true});

  @override
  _PostListWidgetState createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  @override
  Widget build(BuildContext context) {
    PostList _postList = widget.postList;
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              color: Colors.grey[300],
              child:
                  _postList.image != '' ? CachedNetworkImage(imageUrl:_postList.image) : null,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _postList.name,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  _postList.posts.length.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(),
            Container(width: 50,color:Colors.red,),
            widget.activeMoreOptions
                ? Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                          width: 30,
                          child: PostListMoreButton(
                            postList: _postList,
                          )),
                    ),
                  )
                : Container()
          ],
        ),
        onTap: widget.onTap);
  }
}
