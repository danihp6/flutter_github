import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/add_comment_field.dart';
import 'package:meme/Widgets/comment.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/user_avatar.dart';
import '../Models/Comment.dart';

class CommentsPage extends StatelessWidget {
  Post post;
  CommentsPage({@required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Comentarios'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: db.getUser(post.authorId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        if (!snapshot.hasData) return Loading();
                        User user = snapshot.data;
                        return Row(
                      children: [
                        SizedBox(
                            width: 30,
                            height: 30,
                            child: UserAvatar(user: user)),
                        SizedBox(width: 10),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                  text: user.userName + ' ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: post.description),
                            ],
                          ),
                        ),
                      ],
                    );
                      },
                    ),
                    Divider(),
                    StreamBuilder(
                        stream:
                            db.getComments(post.authorId, post.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData) return Loading();
                          List<Comment> parentComments = snapshot.data;
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: parentComments.length,
                              itemBuilder: (context, index) {
                                return CommentWidget(
                                    comment: parentComments[index],
                                    activeInnerComments: true);
                              });
                        }),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: StreamBuilder(
              stream: db.getUser(db.userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                User user = snapshot.data;
                return Container(
                  color: Colors.grey[300],
                  child: AddCommentField(
                    user: user,
                    postId: post.id,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
