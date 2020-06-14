import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Widgets/comment_widget.dart';
import '../Models/Comment.dart';

class CommentsPage extends StatelessWidget {
  String publicationId;
  CommentsPage({@required this.publicationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8,right:8),
            child: StreamBuilder(
                stream: getComments(publicationId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  List<Comment> parentComments =
                      getParentComments(snapshot.data);
                  return ListView.builder(
                      itemCount: parentComments.length,
                      itemBuilder: (context, index) {
                        return CommentWidget(
                            comment: parentComments[index],
                            activeInnerComments: true);
                      });
                }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
