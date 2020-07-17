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

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
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
      body: HomeStream(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HomeStream extends StatelessWidget {
  const HomeStream({
    PageStorageKey key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
        });
  }
}
