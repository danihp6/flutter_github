import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/media_storage.dart';

import '../Models/PostList.dart';
import 'slide_left_route.dart';

class PostListWidget extends StatefulWidget {
  PostList postList;
  bool activeMoreOptions;
  Function onTap;

  PostListWidget({@required this.postList,@required this.onTap,this.activeMoreOptions = true});

  @override
  _PostListWidgetState createState() =>
      _PostListWidgetState();
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
            child: _postList.image != ''
                ? Image.network(_postList.image)
                : null,
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
                style: TextStyle(fontSize: 12,color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(),
          widget.activeMoreOptions?Expanded(
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
                        value: (){if(_postList.imageLocation!='')mediaStorage.deleteFile(_postList.imageLocation); db.deletePostList(db.userId,_postList.id);},
                      )
                    ];
                  },
                  onSelected: (function)=>function(),
                ),
              ),
            ),
          ):Container()
        ],
      ),
      onTap: widget.onTap
    );
  }
}