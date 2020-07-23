import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post.dart';

const int NEXT_POSTS_HOME_PAGE = 10;

class HomePage extends StatefulWidget {
  String userId;
  GlobalKey<ScaffoldState> scaffoldState;
  HomePage({@required this.userId, @required this.scaffoldState});

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
      body: HomeStream(isDescriptionShowed: isDescriptionShowed,scaffoldState: widget.scaffoldState,),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HomeStream extends StatelessWidget {
  HomeStream({this.isDescriptionShowed, this.scaffoldState});
  bool isDescriptionShowed;
  GlobalKey<ScaffoldState> scaffoldState;

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
                        isDescriptionShowed: isDescriptionShowed,
                        scaffoldState: scaffoldState,
                      ));
            },
          );
        });
  }
}
