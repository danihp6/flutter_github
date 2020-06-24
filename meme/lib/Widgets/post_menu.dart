import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/media_storage.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Pages/select_post_list_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class PostMenu extends StatelessWidget {
  Post post;
  String userId;
  PostList postList;

  PostMenu({@required this.post, @required this.userId, this.postList});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Icon(Icons.more_vert),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(
                  width: 5,
                ),
                Text('Añadir a categoria')
              ],
            ),
            value: () => Navigator.push(context,
                SlideLeftRoute(page: SelectPostList(postId: post.getId()))),
          ),
          if (postList == null &&
              post.getAuthorId() == db.userId)
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Eliminar publicación'),
                ],
              ),
              value: () {
                mediaStorage.deleteFile(post.getMediaLocation());
                db.deletePost(userId, post.getId());
              },
            ),
          if (postList != null &&
              postList.getAuthorId() == db.userId)
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.remove),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Quitar de la lista'),
                ],
              ),
              value: () => db.deletePostPathInPostList(db.userId,
                  postList.getId(), 'users/$userId/posts/${post.getId()}'),
            ),
        ];
      },
      onSelected: (function) => function(),
    );
  }
}
