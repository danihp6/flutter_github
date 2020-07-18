import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post.dart';

const int NEXT_POSTS_HOME_PAGE = 10;

class HomePage extends StatefulWidget {
  String userId;
  HomePage({@required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  bool isDescriptionShowed = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Text('Meme'),
          actions: [
            IconButton(
                icon: Icon(
                    isDescriptionShowed ? Icons.comment : Icons.mode_comment),
                onPressed: () {
                  setState(() {
                    isDescriptionShowed = !isDescriptionShowed;
                  });
                })
          ],
        ),
      ),
      body: HomeStream(isDescriptionShowed: isDescriptionShowed),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HomeStream extends StatefulWidget {
  HomeStream({this.isDescriptionShowed});
  bool isDescriptionShowed;
  @override
  _HomeStreamState createState() => _HomeStreamState();
}

class _HomeStreamState extends State<HomeStream> {

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
                  itemCount: posts.length,
                  itemBuilder: (context, index) => PostWidget(
                        post: posts[index],
                        isDescriptionShowed: widget.isDescriptionShowed,
                      ));
            },
          );
        });
  }
}
