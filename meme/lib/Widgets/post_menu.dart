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
  PostList postList;

  PostMenu({@required this.post, this.postList});

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
            value: () => Navigator.push(
                context, SlideLeftRoute(page: SelectPostList(postId: post.id))),
          ),
          if (postList == null && post.author == db.userId)
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
                db.deletePost(db.userId, post.id);
              },
            ),
          if (postList != null && postList.author == db.userId)
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
              value: () => db.deletePostPathInPostList(
                  db.userId, postList.id, post.author, post.id),
            ),
        ];
      },
      onSelected: (function) => function(),
    );
  }
}
