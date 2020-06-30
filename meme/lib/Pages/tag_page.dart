import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/Tag.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post.dart';

class TagPage extends StatelessWidget {
  String tagId;
  TagPage({@required this.tagId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db.getTag(tagId),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return Loading();
          Tag tag = snapshot.data;
          List<DocumentReference> posts = tag.posts;
          print(posts.first.path);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepOrange,
              title: Text('#' + tag.name),
            ),
            body: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) => StreamBuilder(
                stream: db.getPost(posts[index].path),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return Loading();
                  Post post = snapshot.data;
                  return PostWidget(post: post);
                },
              ),
            ),
          );
        });
  }
}
