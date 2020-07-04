import 'package:flutter/material.dart';
import 'package:meme/Controller/auth.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/post_list_page.dart';
import 'package:meme/Pages/post_page.dart';
import 'package:meme/Pages/settings_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/new_post_list_button.dart';
import 'package:meme/Widgets/post.dart';
import 'package:meme/Widgets/post_list.dart';
import 'package:meme/Widgets/post_list_carousel.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_page_header.dart';

class UserPage extends StatefulWidget {
  String userId;
  bool activeAppBar;
  Function refresh;
  UserPage({@required this.userId, this.activeAppBar = true, this.refresh});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

      goPostList(PostList postList)=>
    Navigator.of(context)
          .push(SlideLeftRoute(page: PostListPage(postList: postList)));

          goPost(Post post)=>
    Navigator.of(context)
          .push(SlideLeftRoute(page: PostPage(post: post)));

    return SafeArea(
      child: StreamBuilder(
          stream: db.getUser(widget.userId),
          builder: (context, snap) {
            if (snap.hasError) print(snap.error);
            if (!snap.hasData) return Loading();
            User user = snap.data;
            List<String> favourites = user.favourites;
            return Scaffold(
              key: scaffoldKey,
              endDrawer: Container(
                width: 170,
                child: Drawer(
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                          onPressed: () => Navigator.push(
                              context, SlideLeftRoute(page: SettingsPage())),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(Icons.settings),
                              Text('Configuración'),
                            ],
                          )),
                      FlatButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(Icons.mail),
                              Text('Contactar'),
                            ],
                          )),
                      FlatButton(
                          onPressed: () =>
                              auth.signOut().then((_) => widget.refresh()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(Icons.exit_to_app),
                              Text('Cerrar sesión'),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              appBar: widget.activeAppBar
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(40),
                      child: AppBar(
                        backgroundColor: Colors.deepOrange,
                        title: Text(user.userName),
                      ),
                    )
                  : null,
              body: NestedScrollView(
                headerSliverBuilder: (context, _) => [
                  SliverToBoxAdapter(
                      child:
                          UserPageHeader(user: user, scaffoldKey: scaffoldKey)),
                  SliverToBoxAdapter(
                    child: TabBar(
                      controller: tabController,
                      tabs: [
                        Tab(
                          icon: Icon(
                            Icons.photo_library,
                            size: 30,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.star,
                            size: 30,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.perm_media,
                            size: 30,
                          ),
                        ),
                      ],
                      labelColor: Colors.deepOrange,
                      unselectedLabelColor: Colors.black,
                    ),
                  ),
                ],
                body: TabBarView(
                    controller: tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      StreamBuilder(
                        stream: db.getPosts(user.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData) return Loading();
                          List<Post> posts = snapshot.data;
                          if (posts.length == 0)
                            return Center(
                                child: Text('Usuario sin publicaciones'));
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: posts.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return PostWidget(post: posts[index]);
                            },
                          );
                        },
                      ),
                      favourites.length == 0
                          ? Center(child: Text('Usuario sin favoritos'))
                          : ListView.builder(
                              itemCount: favourites.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return StreamBuilder(
                                    stream: db.getPostByPath(favourites[index]),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError)
                                        print(snapshot.error);
                                      if (!snapshot.hasData) return Loading();
                                      Post post = snapshot.data;
                                      return PostWidget(post: post);
                                    });
                              },
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          children: [
                            user.id == db.userId
                                ? NewPostListButton()
                                : Container(),
                            Expanded(
                              child: StreamBuilder(
                                stream: db.getPostLists(user.id),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) print(snapshot.error);
                                  if (!snapshot.hasData) return Loading();
                                  List<PostList> postlists = snapshot.data;
                                  if (postlists.length == 0)
                                    return Center(
                                        child: Text('Usuario sin listas'));
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: postlists.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return PostListCarousel(
                                        postList: postlists[index],
                                        onTapPostList: goPostList,
                                        onTapPost: goPost,
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
              ),
            );
          }),
    );
  }
}
