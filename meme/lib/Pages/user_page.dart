import 'package:flutter/material.dart';
import 'package:meme/Controller/auth.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/post_list_page.dart';
import 'package:meme/Pages/post_page.dart';
import 'package:meme/Pages/account_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post_list_new_button.dart';
import 'package:meme/Widgets/post.dart';
import 'package:meme/Widgets/post_list.dart';
import 'package:meme/Widgets/post_list_carousel.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_more_button.dart';
import 'package:meme/Widgets/user_page_header.dart';
import 'contact_page.dart';

class UserPage extends StatefulWidget {
  String userId;
  GlobalKey<ScaffoldState> scaffoldState;
  UserPage({@required this.userId, this.scaffoldState});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  GlobalKey<ScaffoldState> _scaffoldState;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
    if (widget.scaffoldState == null)
      _scaffoldState = GlobalKey<ScaffoldState>();
    else
      _scaffoldState = widget.scaffoldState;
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder(
            stream: db.getUser(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return Loading();
              User user = snapshot.data;
              List<String> blockedUsers = user.blockedUsers;
              bool blocked = blockedUsers.contains(db.userId);
              if (widget.userId != db.userId)
                return StreamBuilder(
                    stream: db.getUser(db.userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      if (!snapshot.hasData) return Loading();
                      User currentUser = snapshot.data;
                      List<String> yourBblockedUsers = currentUser.blockedUsers;
                      if (blocked == false)
                        blocked = yourBblockedUsers.contains(user.id);

                      return UserPageBody(
                          user: user,
                          scaffoldState: _scaffoldState,
                          tabController: tabController,
                          blocked: blocked);
                    });
              return UserPageBody(
                  user: user,
                  scaffoldState: _scaffoldState,
                  tabController: tabController);
            }));
  }
}

class UserPageBody extends StatelessWidget {
  UserPageBody(
      {@required this.user,
      @required this.scaffoldState,
      @required this.tabController,
      this.blocked});

  User user;
  GlobalKey<ScaffoldState> scaffoldState;
  TabController tabController;
  bool blocked;

  @override
  Widget build(BuildContext context) {
    List<String> favourites = user.favourites;
    goPostList(PostList postList) => Navigator.of(context)
        .push(SlideLeftRoute(page: PostListPage(postList: postList)));

    goPost(Post post) => Navigator.of(context).push(SlideLeftRoute(
            page: PostPage(
          authorId: post.author,
          postId: post.id,
        )));
    return Scaffold(
      key: scaffoldState == null ? scaffoldState : null,
      endDrawer: user.id == db.userId
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
          title: Text(user.userName),
          actions: <Widget>[
            if (blocked != null)
              UserMoreButton(
                user: user,
                scaffoldState: scaffoldState,
                blocked: blocked,
              )
          ],
        ),
      ),
      body: blocked==null||!blocked
          ? NestedScrollView(
              headerSliverBuilder: (context, _) => [
                SliverToBoxAdapter(
                    child: UserPageHeader(
                        user: user, scaffoldState: scaffoldState)),
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
                            return PostWidget(
                              post: posts[index],
                              scaffoldState: scaffoldState,
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
                                      scaffoldState: scaffoldState,
                                    );
                                  });
                            },
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        children: [
                          user.id == db.userId
                              ? PostListNewButton()
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
            )
          : Center(
              child: Text('Usuario bloqueado', style: TextStyle(fontSize: 16))),
    );
  }
}
