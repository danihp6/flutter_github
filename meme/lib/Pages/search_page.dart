import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/Tag.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/post_list_page.dart';
import 'package:meme/Pages/tag_page.dart';
import 'package:meme/Widgets/follow_button.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post.dart';
import 'package:meme/Widgets/post_list.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_avatar.dart';
import '../Controller/db.dart';
import 'post_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  SearchBarController searchBarController;
  FocusNode focusNode;
  String typeSearched = 'users';
  bool isRecentsView = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    searchBarController = SearchBarController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus)
        isRecentsView = true;
      else {
        isRecentsView = false;
        searchBarController.clear();
      }
      setState(() {
        
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    searchBarController = null;
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> search(String search) {
      search = search.toLowerCase();
      if (search[0] == '@') {
        typeSearched = 'users';
        return db.userSearch(search.substring(1));
      }
      if (search[0] == '#') {
        typeSearched = 'tags';
        return db.tagSearch(search.substring(1));
      }
      if (search[0] == '&') {
        typeSearched = 'postLists';
        return db.postListSearch(search.substring(1));
      }
      if (tabController.index == 0) return db.userSearch(search);

      if (tabController.index == 1) return db.tagSearch(search);

      if (tabController.index == 2) return db.postListSearch(search);
    }

    Future<bool> onWillPop() async {
      if(isRecentsView){
        focusNode.unfocus();
        return false;
      }
      Navigator.pop(context);
      return true;
    }

    return WillPopScope(
      onWillPop: onWillPop,
          child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                  child: SearchBar(
                      onSearch: search,
                      searchBarController: searchBarController,
                      focusNode: focusNode,
                      icon: isRecentsView
                          ? SizedBox(
                              width: 25,
                              child: IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    focusNode.unfocus();
                                  }),
                            )
                          : Icon(Icons.search),
                      emptyWidget:
                          Center(child: Text('No se han encontrado resultados')),
                      hintText: 'Busca...',
                      iconActiveColor: Colors.deepOrange,
                      crossAxisSpacing: 20,
                      searchBarPadding: EdgeInsets.only(left: 8, right: 8),
                      minimumChars: 1,
                      placeHolder: !isRecentsView
                          ? StreamBuilder(
                              stream: db.getTendTags(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                if (!snapshot.hasData) return Loading();
                                List<Tag> tags = snapshot.data;
                                return ListView.builder(
                                    itemCount: tags.length,
                                    itemBuilder: (context, index) {
                                      Tag tag = tags[index];
                                      List<DocumentReference> posts = tag.posts;
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    3)),
                                                        color: Colors.grey[300],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                4),
                                                        child: Text(
                                                          '#' + tag.name,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    tag.posts.length.toString() +
                                                        ' publicación',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  )
                                                ],
                                              ),
                                              onTap: () => Navigator.push(
                                                  context,
                                                  SlideLeftRoute(
                                                      page: TagPage(
                                                    tagId: tag.id,
                                                  ))),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 200,
                                              child: ListView.separated(
                                                itemCount: posts.length,
                                                scrollDirection: Axis.horizontal,
                                                separatorBuilder:
                                                    (context, index) => SizedBox(
                                                  width: 5,
                                                ),
                                                itemBuilder: (context, index) =>
                                                    StreamBuilder(
                                                  stream: db
                                                      .getPost(posts[index].path),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasError)
                                                      print(snapshot.error);
                                                    if (!snapshot.hasData)
                                                      return Loading();
                                                    Post post = snapshot.data;
                                                    return GestureDetector(
                                                      child: post.mediaType=='image'?Image.network(
                                                          post.media):null,
                                                      onTap: () => Navigator.push(
                                                          context,
                                                          SlideLeftRoute(
                                                              page: PostPage(
                                                            post: post,
                                                          ))),
                                                    );
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              })
                          : null,
                      onItemFound: (item, index) {
                        if (typeSearched == 'users')
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    UserAvatar(
                                      user: item,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      item.userName,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                FollowButton(userId: item.id)
                              ],
                            ),
                          );
                        if (typeSearched == 'tags')
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(3)),
                                        color: Colors.grey[300],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          '#' + item.name,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    item.posts.length.toString() + ' publicación',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              onTap: () => Navigator.push(context,
                                  SlideLeftRoute(page: TagPage(tagId: item.id))),
                            ),
                          );

                        if (typeSearched == 'postLists')
                          return StreamBuilder(
                              stream: db.getPostList(item),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                if (!snapshot.hasData) return Loading();
                                PostList postList = snapshot.data;
                                return PostListWidget(
                                  postList: postList,
                                  onTap: () => Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                          page: PostListPage(
                                        postList: postList,
                                      ))),
                                );
                              });
                      },
                      header: isRecentsView
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: TabBar(
                                      controller: tabController,
                                      labelStyle: TextStyle(fontSize: 15),
                                      labelColor: Colors.black,
                                      indicatorColor: Colors.deepOrange,
                                      onTap: (value) {
                                        if (value == 0) typeSearched = 'users';
                                        if (value == 1) typeSearched = 'tags';
                                        if (value == 2)
                                          typeSearched = 'postLists';
                                        searchBarController.replayLastSearch();
                                      },
                                      tabs: [
                                        Tab(
                                          text: 'Usuarios',
                                        ),
                                        Tab(
                                          text: 'Tags',
                                        ),
                                        Tab(
                                          text: 'Listas',
                                        )
                                      ]),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            )
                          : null)),
            ],
          ),
        ),
      ),
    );
  }
}
