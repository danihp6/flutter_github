import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/datetime_functions.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/comments_page.dart';
import 'package:meme/Widgets/add_comment_field.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/tag_selector.dart';
import 'package:meme/Widgets/tags_viewer.dart';

import 'comment.dart';

class PostDescription extends StatelessWidget {
  Post post;
  PostDescription({
    @required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (post.description != '')
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              post.description,
              style: TextStyle(fontSize: 15),
            ),
          ),
        if (post.keyWords.length > 0)
          SizedBox(
            height: 30,
            child: TagViewer(
              tags: post.keyWords.map((keyWord)=>'#'+keyWord).toList(),
              activeOnClearTag: false,
            ),
          ),
          SizedBox(height: 3,),
        StreamBuilder(
            stream: db.getBestComment(post.authorId, post.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return Container();
              Comment bestComment = snapshot.data;
              return Column(
                children: [
                  CommentWidget(
                    comment: bestComment,
                    activeInnerComments: false,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: 20,
                      child: FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.all(0),
                          onPressed: () =>
                              Navigator.of(context).push(SlideLeftRoute(
                                  page: CommentsPage(
                                post: post,
                              ))),
                          child: Text('Ver todos los comentarios')),
                    ),
                  ),
                ],
              );
            }),
        StreamBuilder(
            stream: db.getUser(db.userId),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return Loading();
              User user = snapshot.data;
              return SizedBox(
                  height: 50,
                  child: AddCommentField(user: user, postId: post.id));
            }),
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Publicada hace ' + getPastTime(post.dateTime),
              style: TextStyle(fontSize: 13),
            )),
      ],
    );
  }
}
