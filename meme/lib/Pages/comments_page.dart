import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/add_comment_field.dart';
import 'package:meme/Widgets/comment.dart';
import 'package:meme/Widgets/loading.dart';
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
                            stream: getUser(post.getAuthorId()),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              if (!snapshot.hasData)
                                return Loading();
                              User user = snapshot.data;
                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundImage:
                                        NetworkImage(user.getAvatar()),
                                  ),
                                  SizedBox(width: 10),
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                            text: user.getUserName() + ' ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: post.getDescription()),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                    Divider(),
                    StreamBuilder(
                        stream: getComments(post.getAuthorId(),post.getId()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData)
                            return Loading();
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
              stream: getUser(configuration.getUserId()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                User user = snapshot.data;
                return Container(
                  color: Colors.grey[300],
                  child: AddCommentField(
                    user: user,
                    postId: post.getId(),
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
