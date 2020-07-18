import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post.dart';

class PostPage extends StatelessWidget {
  String postId;
  String authorId;
  
  PostPage({@required this.authorId,@required this.postId});

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            title: Text('Publicacion'),
          ),
        ),
        body: SingleChildScrollView(
                  child: StreamBuilder(
              stream: db.getPost(authorId,postId),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                Post post = snapshot.data;
                return PostWidget(post: post,scaffoldState: scaffoldState,);
              }),
        ),
      ),
    );
  }
}
