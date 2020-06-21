import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/post.dart';

class HomePage extends StatelessWidget {
  String userId;
  HomePage({@required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: getFollowed(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (!snapshot.hasData) return CircularProgressIndicator();
        List<String> usersId = snapshot.data;
        return ListView.builder(
          itemCount: usersId.length,
          itemBuilder: (context, index) => StreamBuilder(
              stream: getLastlyPosts(usersId[index]),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return CircularProgressIndicator();
                List<Post> posts = snapshot.data;
                orderListPostByDateTime(posts);
                print(posts);
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, j) => PostWidget(post: posts[j]));
              }),
        );
      },
    ));
  }
}
