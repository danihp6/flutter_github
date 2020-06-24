import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post.dart';

class PostPage extends StatelessWidget {
  String postId;
  String userId;
  PostPage({@required this.userId, @required this.postId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.deepOrange,
            title: Text('Publicacion'),
          ),
        ),
        body: SingleChildScrollView(
                  child: StreamBuilder(
              stream: db.getPost('users/$userId/posts/$postId'),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                Post post = snapshot.data;
                return PostWidget(post: post,activeAlwaysShowedComments: true,);
              }),
        ),
      ),
    );
  }
}
