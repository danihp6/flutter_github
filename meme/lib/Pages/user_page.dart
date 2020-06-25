import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/post_list_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/new_post_list_button.dart';
import 'package:meme/Widgets/post.dart';
import 'package:meme/Widgets/post_list.dart';
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
  PostList postList;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    goToPostList() {
      Navigator.of(context)
          .push(SlideLeftRoute(page: PostListPage(postList: postList)));
    }

    return SafeArea(
      child: StreamBuilder(
          stream: db.getUser(widget.userId),
          builder: (context, snap) {
            if (snap.hasError) print(snap.error);
            if (!snap.hasData) return Loading();
            User user = snap.data;
            return Scaffold(
              appBar: widget.activeAppBar
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(40),
                      child: AppBar(
                        backgroundColor: Colors.deepOrange,
                        title: Text(user.getUserName()),
                      ),
                    )
                  : null,
              body: NestedScrollView(
                headerSliverBuilder: (context, _) => [
                  SliverToBoxAdapter(
                      child:
                          UserPageHeader(user: user, refresh: widget.refresh)),
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
                      indicatorColor: Colors.deepOrange,
                    ),
                  ),
                ],
                body: TabBarView(
                    controller: tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      StreamBuilder(
                        stream: db.getPosts(user.getId()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData) return Loading();
                          List<Post> posts = snapshot.data;
                          if (posts.length == 0)
                            return Center(child: Text('Usuario sin publicaciones'));
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
                      StreamBuilder(
                        stream: db.getPostsPathFromFavourites(user.getId()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData) return Loading();
                          List<String> postsId = snapshot.data;
                          if (postsId.length == 0)
                            return Center(child: Text('Usuario sin favoritos'));
                          return ListView.builder(
                            itemCount: postsId.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return StreamBuilder(
                                  stream: db.getPost(postsId[index]),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError)
                                      print(snapshot.error);
                                    if (!snapshot.hasData) return Loading();
                                    Post post = snapshot.data;
                                    return PostWidget(post: post);
                                  });
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          children: [
                            user.getId() == db.userId
                                ? NewPostListButton()
                                : Container(),
                            Expanded(
                              child: StreamBuilder(
                                stream: db.getPostLists(user.getId()),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError)
                                    print(snapshot.error);
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
                                      return PostListWidget(
                                        postList: postlists[index],
                                        onTap: () {
                                          postList = postlists[index];
                                          goToPostList();
                                        },
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
