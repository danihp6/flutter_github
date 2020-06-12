import 'package:flutter/material.dart';
import '../Models/Comment.dart';

class CommentsPage extends StatelessWidget {
  List<Comment> comments;
  CommentsPage({this.comments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: null
        ),
    );
  }
}