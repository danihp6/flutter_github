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

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db.getTag(tagId),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return Loading();
          Tag tag = snapshot.data;
          List<String> posts = tag.posts;
          return Scaffold(
            key: scaffoldState,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
                          child: AppBar(
                title: Text('#' + tag.name),
                actions: <Widget>[
                  Center(child: Text(tag.totalPoints.toString(),style:TextStyle(
                    fontSize: 16
                  ))),
                  SizedBox(width: 5,),
                  Icon(Icons.whatshot),
                  SizedBox(width:5)
                ],
              ),
            ),
            body: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) => StreamBuilder(
                stream: db.getPostByPath(posts[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return Loading();
                  Post post = snapshot.data;
                  return PostWidget(post: post,scaffoldState: scaffoldState,);
                },
              ),
            ),
          );
        });
  }
}
