import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/add_comment_field.dart';
import 'package:meme/Widgets/comment_widget.dart';
import '../Models/Comment.dart';

class CommentsPage extends StatelessWidget {
  String publicationId;
  CommentsPage({@required this.publicationId});

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
                      stream: getPublication(publicationId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        Publication publication = snapshot.data;
                        return StreamBuilder(
                            stream: getUser(publication.getAuthorId()),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();
                              User user = snapshot.data;
                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundImage:
                                        NetworkImage(user.getImage()),
                                  ),
                                  SizedBox(width: 10),
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                            text: user.getName() + ' ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: publication.getDescription()),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                    Divider(),
                    StreamBuilder(
                        stream: getComments(publicationId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          List<Comment> parentComments =
                              getParentComments(snapshot.data);
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
                if (!snapshot.hasData) return CircularProgressIndicator();
                User user = snapshot.data;
                return Container(
                  color: Colors.grey[300],
                  child: AddCommentField(
                    user: user,
                    publicationId: publicationId,
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
