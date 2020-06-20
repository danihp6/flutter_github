
import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Pages/select_post_list_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class PostMenu extends StatelessWidget {
  Post post;
  String userId;
  PostList postList;

  PostMenu(
      {@required this.post,
      @required this.userId,
      this.postList});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Icon(Icons.more_vert),
      itemBuilder: (context) {
        return [
          if(postList == null  && post.getAuthorId() == configuration.getUserId())
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.delete),
                Text('Eliminar publicación'),
              ],
            ),
            value: ()=>deletePost(userId, post.getId()),
          ),
          if(postList != null  && postList.getAuthorId() == configuration.getUserId())
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.remove),
                Text('Quitar de la lista'),
              ],
            ),
            value: () => deletePostPathInPostList(configuration.getUserId(),postList.getId(),'users/$userId/posts/${post.getId()}'),
          ),
          PopupMenuItem(
            child: Row(
              children: [Icon(Icons.add), Text('Añadir a categoria')],
            ),
            value: () => Navigator.push(
                context,
                SlideLeftRoute(
                    page: SelectPostList(
                        postId: post.getId()))),
          )
        ];
      },
      onSelected: (function) => function(),
    );
  }
}