import 'package:flutter/material.dart';
import 'package:meme/Widgets/comment_widget.dart';
import '../Models/Comment.dart';

class CommentsPage extends StatelessWidget {
  List<Comment> comments;
  CommentsPage({this.comments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left:8,right:8),
        child: ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context,index){
            return SizedBox(child: CommentWidget(comment:comments[index],activeInnerComments: true,level:0));
          }
          ),
      ),
    );
  }
}