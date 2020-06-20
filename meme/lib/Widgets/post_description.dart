import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/comments_page.dart';
import 'package:meme/Widgets/add_comment_field.dart';
import 'package:meme/Widgets/slide_left_route.dart';

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
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            post.getDescription(),
            style: TextStyle(fontSize: 15),
          ),
        ),
        StreamBuilder(
            stream: getBestComment(post.getAuthorId(),post.getId()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return Container();
              Comment bestComment = snapshot.data;
              return Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CommentWidget(
                        comment: bestComment,
                        activeInnerComments: false,
                      )),
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
            stream: getUser(configuration.getUserId()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return CircularProgressIndicator();
              User user = snapshot.data;
              return SizedBox(
                  height: 50,
                  child: AddCommentField(
                      user: user, postId: post.getId()));
            }),
        Align(alignment:Alignment.topLeft,child: Text('Publicada hace ' + post.getPastTime(),style: TextStyle(
          fontSize: 13
        ),)),
      ],
    );
  }
}
