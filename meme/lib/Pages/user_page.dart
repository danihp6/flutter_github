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
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_more_button.dart';
import 'package:meme/Widgets/user_page_header.dart';
import 'contact_page.dart';

class UserPage extends StatelessWidget {
  String userId;
  GlobalKey<ScaffoldState> scaffoldState;
  UserPage({@required this.userId, this.scaffoldState});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stream2Users(
      userId: userId,
      scaffoldState: scaffoldState,
      childNotCurrentUser: (user, scaffoldState, blocked, youAreBlocked) =>
          UserPageBody(
              user: user,
              scaffoldState: scaffoldState,
              blocked: blocked,
              youAreBlocked: youAreBlocked),
      childCurrentUser: (currentUser, scaffoldState) => UserPageBody(
        user: currentUser,
        scaffoldState: scaffoldState,
      ),
    ));
  }
}

class UserPageBody extends StatefulWidget {
  UserPageBody(
      {@required this.user,
      @required this.scaffoldState,
      this.blocked,
      this.youAreBlocked});

  User user;
  GlobalKey<ScaffoldState> scaffoldState;
  bool blocked;
  bool youAreBlocked;

  @override
  _UserPageBodyState createState() => _UserPageBodyState();
}

class _UserPageBodyState extends State<UserPageBody>
    with SingleTickerProviderStateMixin {
  TabController tabController;
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

  @override
  Widget build(BuildContext context) {
    if (widget.scaffoldState == null)
      widget.scaffoldState = GlobalKey<ScaffoldState>();
    List<String> favourites = widget.user.favourites;
    goPostList(PostList postList) => Navigator.of(context)
        .push(SlideLeftRoute(page: PostListPage(postList: postList)));

    goPost(Post post) => Navigator.of(context).push(SlideLeftRoute(
            page: PostPage(
          authorId: post.author,
          postId: post.id,
        )));
    return Scaffold(
      key: widget.scaffoldState,
      endDrawer: widget.user.id == db.userId
          ? Container(
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
            )
          : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(widget.user.userName),
          actions: <Widget>[
            if (widget.blocked != null)
              UserMoreButton(
                  user: widget.user,
                  scaffoldState: widget.scaffoldState,
                  blocked: widget.blocked,
                  youAreBlocked: widget.youAreBlocked)
          ],
        ),
      ),
      body: widget.blocked == null || !widget.blocked && !widget.youAreBlocked
          ? NestedScrollView(
              headerSliverBuilder: (context, _) => [
                SliverToBoxAdapter(
                    child: UserPageHeader(
                        user: widget.user,
                        scaffoldState: widget.scaffoldState)),
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
                      stream: db.getPosts(widget.user.id),
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
                            return PostWidget(
                              post: posts[index],
                              scaffoldState: widget.scaffoldState,
                            );
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
                                    return PostWidget(
                                      post: post,
                                      scaffoldState: widget.scaffoldState,
                                    );
                                  });
                            },
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        children: [
                          widget.user.id == db.userId
                              ? PostListNewButton()
                              : Container(),
                          Expanded(
                            child: StreamBuilder(
                              stream: db.getPostLists(widget.user.id),
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
            )
          : Center(
              child: Text('Usuario bloqueado', style: TextStyle(fontSize: 16))),
    );
  }
}
