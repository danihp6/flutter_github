import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/new_post_list_button.dart';
import 'package:meme/Widgets/post.dart';
import 'package:meme/Widgets/post_list.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import '../Pages/post_list_page.dart';

class UserPageBody extends StatefulWidget {
  UserPageBody({
    @required this.user,
  });

  User user;

  @override
  _UserPageBodyState createState() => _UserPageBodyState();
}

class _UserPageBodyState extends State<UserPageBody>
    with SingleTickerProviderStateMixin {
  TabController tabController;

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
    PostList postList;

    goToPostList() {
      Navigator.of(context)
          .push(SlideLeftRoute(page: PostListPage(postList: postList)));
    }

    return Column(
      children: [
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
          indicatorColor: Colors.deepOrange,
        ),
        Expanded(
          child: TabBarView(
              controller: tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                StreamBuilder(
                  stream: getPosts(widget.user.getId()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    List<Post> posts = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostWidget(post: posts[index]);
                      },
                    );
                  },
                ),
                StreamBuilder(
                  stream: getPostsPathFromFavourites(widget.user.getId()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    List<String> postsId = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: postsId.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: getPost(postsId[index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();
                              Post post = snapshot.data;
                              return PostWidget(post: post);
                            });
                      },
                    );
                  },
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      children: [
                        NewPostListButton(userId: widget.user.getId()),
                        Column(
                          children: [
                            StreamBuilder(
                              stream: getPostLists(widget.user.getId()),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                if (!snapshot.hasData)
                                  return CircularProgressIndicator();
                                List<PostList> postlists = snapshot.data;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: postlists.length,
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
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ]),
        ),
      ],
    );
  }
}
