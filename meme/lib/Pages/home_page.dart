import 'package:flutter/material.dart';
import 'package:meme/Controller/configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/comments_button.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post.dart';
import 'package:rxdart/streams.dart';

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
          stream: db.getUser(db.userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (!snapshot.hasData) return Loading();
            User user = snapshot.data;
            List<String> followed = user.followed;
            followed.add(db.userId);
            return StreamBuilder(
              stream: db.getFollowedPosts(followed),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                var posts = snapshot.data;
                print(posts);
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: posts.length,
                    itemBuilder: (context, index) =>
                        PostWidget(post: posts[index]));
              },
            );
          }),
      // body: StreamBuilder(
      //     stream: db.getUser(db.userId),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasError) print(snapshot.error);
      //       if (!snapshot.hasData) return Loading();
      //       User user = snapshot.data;
      //       List<String> followedList = user.followed;
      //       followedList.add(db.userId);
      //       return StreamBuilder(
      //           stream: CombineLatestStream.list(
      //               followedList.map((followed) => db.getPosts(followed))).asBroadcastStream(),
      //           builder: (context, snapshot) {
      //             if (snapshot.hasError) print(snapshot.error);
      //             if (!snapshot.hasData) return Loading();
      //             print(snapshot.data);
      //             List<List<Post>> followedPosts = snapshot.data;
      //             List<Post> posts = followedPosts.expand((post)=>post).toList();
      //             orderListPostByDateTime(posts);
      //             return ListView.builder(
      //                 shrinkWrap: true,
      //                 physics: NeverScrollableScrollPhysics(),
      //                 itemCount: posts.length,
      //                 itemBuilder: (context, index) =>
      //                     PostWidget(post: posts[index]));
      //           });
      //     })
    );
  }
}
