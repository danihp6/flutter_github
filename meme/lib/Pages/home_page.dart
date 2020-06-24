import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/comments_button.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post.dart';

class HomePage extends StatefulWidget {
  String userId;
  HomePage({@required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            backgroundColor: Colors.deepOrange,
            title: Text('Meme'),
            actions: [
              CommentsButton(
                refresh: () {
                  setState(() {});
                },
              )
            ],
          ),
        ),
        body: StreamBuilder(
          stream: db.getFollowed(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (!snapshot.hasData) return Loading();
            List<String> usersId = snapshot.data;
            return ListView.builder(
              itemCount: usersId.length,
              itemBuilder: (context, index) => StreamBuilder(
                  stream: db.getLastlyPosts(usersId[index]),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return Loading();
                    List<Post> posts = snapshot.data;
                    orderListPostByDateTime(posts);
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, j) =>
                            PostWidget(post: posts[j]));
                  }),
            );
          },
        ));
  }
}
