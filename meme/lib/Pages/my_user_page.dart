import 'package:flutter/material.dart';
import 'package:meme/Controller/auth.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/post_list_page.dart';
import 'package:meme/Pages/post_page.dart';
import 'package:meme/Pages/account_page.dart';
import 'package:meme/Widgets/Stream2Users.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post_list_new_button.dart';
import 'package:meme/Widgets/post.dart';
import 'package:meme/Widgets/post_list.dart';
import 'package:meme/Widgets/post_list_carousel.dart';
import 'package:meme/Widgets/share_button.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_more_button.dart';
import 'package:meme/Widgets/user_page_header.dart';
import 'package:rxdart/streams.dart';
import 'contact_page.dart';
import 'package:animated_stream_list/animated_stream_list.dart';

class MyUserPage extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldState;
  MyUserPage({this.scaffoldState});

  @override
  _MyUserPageState createState() => _MyUserPageState();
}

class _MyUserPageState extends State<MyUserPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  final Key keyPosts = PageStorageKey('posts');
  final Key keyFavourites = PageStorageKey('favourites');
  final Key keyPostLists = PageStorageKey('postLists');

  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  goPostList(PostList postList) => Navigator.of(context)
      .push(SlideLeftRoute(page: PostListPage(postList: postList)));

  goPost(Post post) => Navigator.of(context).push(SlideLeftRoute(
          page: PostPage(
        authorId: post.author,
        postId: post.id,
      )));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder(
            stream: db.getUser(db.userId),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return Loading();
              User user = snapshot.data;
              List<String> favourites = user.favourites;
              return Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(40),
                    child: AppBar(
                      title: Text(user.userName),
                    ),
                  ),
                  endDrawer: Container(
                    width: 170,
                    child: Drawer(
                      child: Column(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.settings),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Configuración'),
                                ],
                              )),
                          FlatButton(
                              onPressed: () => Navigator.push(
                                  context, SlideLeftRoute(page: ContactPage())),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.mail),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Contactar'),
                                ],
                              )),
                          FlatButton(
                              onPressed: () => Navigator.push(
                                  context, SlideLeftRoute(page: AccountPage())),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.person),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Cuenta'),
                                ],
                              )),
                          FlatButton(
                              onPressed: () => auth.signOut(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.exit_to_app),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Cerrar sesión'),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                  body: NestedScrollView(
                    headerSliverBuilder: (context, _) => [
                      SliverToBoxAdapter(
                          child: UserPageHeader(
                        user: user,
                        scaffoldState: widget.scaffoldState,
                      ))
                    ],
                    body: Column(
                      children: <Widget>[
                        TabBar(
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
                        Expanded(
                          child: TabBarView(
                              controller: tabController,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                StreamBuilder(
                                  stream: db.getPosts(db.userId),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError)
                                      print(snapshot.error);
                                    if (!snapshot.hasData) return Loading();
                                    List<Post> posts = snapshot.data;
                                    return ListView.builder(
                                      key: keyPosts,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: posts.length,
                                      itemBuilder: (context, index) =>
                                          PostWidget(
                                        post: posts[index],
                                        scaffoldState: widget.scaffoldState,
                                      ),
                                    );
                                  },
                                ),
                                favourites.isNotEmpty
                                    ? StreamBuilder(
                                        stream: CombineLatestStream.list(
                                                favourites.map((favourite) => db
                                                    .getPostByPath(favourite)))
                                            .asBroadcastStream(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError)
                                            print(snapshot.error);
                                          if (!snapshot.hasData)
                                            return Loading();
                                          List<Post> posts = snapshot.data;
                                          print(posts);
                                          return ListView.builder(
                                            key: keyFavourites,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: posts.length,
                                            itemBuilder: (context, index) =>
                                                PostWidget(
                                              post: posts[index],
                                              scaffoldState:
                                                  widget.scaffoldState,
                                            ),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Text('Usuario sin favoritos')),
                                Column(
                                  children: <Widget>[
                                    PostListNewButton(),
                                    Expanded(
                                      child: StreamBuilder(
                                        stream: db.getPostLists(db.userId),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError)
                                            print(snapshot.error);
                                          if (!snapshot.hasData)
                                            return Loading();
                                          List<PostList> postlists =
                                              snapshot.data;
                                          if (postlists.length == 0)
                                            return Center(
                                                child:
                                                    Text('Usuario sin listas'));
                                          return ListView.builder(
                                            key: keyPostLists,
                                            shrinkWrap: true,
                                            itemCount: postlists.length,
                                            physics:
                                                NeverScrollableScrollPhysics(),
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
                                    ),
                                  ],
                                )
                              ]),
                        ),
                      ],
                    ),
                  ));
            }));
  }
}
