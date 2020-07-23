import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/local_storage.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/Tag.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/post_list_page.dart';
import 'package:meme/Pages/tag_page.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/posts_carousel.dart';
import 'package:meme/Widgets/post_list.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/tag.dart';
import 'package:meme/Widgets/user_avatar.dart';
import 'package:meme/Widgets/user_row.dart';
import 'package:rxdart/rxdart.dart';

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
    tabController.addListener(() {
      if (tabController.index != tabController.previousIndex) setState(() {});
    });
    searchBarController = SearchBarController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus)
        isRecentsView = true;
      else {
        isRecentsView = false;
        searchBarController.clear();
      }
      setState(() {});
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
      print(search);
      if (search[0] == '@') {
        typeSearched = 'users';
        print('-------------------users');
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
      if (isRecentsView) {
        focusNode.unfocus();
        return false;
      }
      navigator.pop(context);
      return true;
    }

    Widget recentsView() {
      if (tabController.index == 0)
        return storage.recentUsers.isNotEmpty
            ? StreamBuilder(
                stream: CombineLatestStream.list(
                        storage.recentUsers.map((user) => db.getUser(user)))
                    .asBroadcastStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return Loading();
                  List<User> users = snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            child: Row(
                              children: <Widget>[
                                UserAvatar(user: users[index]),
                                SizedBox(width: 10),
                                Text(users[index].userName,
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            onTap: () => navigator.goUser(context, users[index].id),
                          ),
                          IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                var newRecentUsers = storage.recentUsers;
                                newRecentUsers.remove(users[index].id);
                                storage.recentUsers = newRecentUsers;
                                setState(() {});
                              })
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text('No hay busquedas de usuarios recientes'),
              );
      if (tabController.index == 1)
        return storage.recentTags.isNotEmpty
            ? StreamBuilder(
                stream: CombineLatestStream.list(
                        storage.recentTags.map((tag) => db.getTag(tag)))
                    .asBroadcastStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return Loading();
                  List<Tag> tags = snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: tags.length,
                      itemBuilder: (context, index) => GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TagWidget(
                                tag: tags[index],
                                onTap: () => navigator.goTag(context, tags[index].id)),
                            IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  var newRecentTags = storage.recentTags;
                                  newRecentTags.remove(tags[index].id);
                                  storage.recentTags = newRecentTags;
                                  setState(() {});
                                })
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text('No hay busquedas de tags recientes'),
              );
      if (tabController.index == 2)
        return storage.recentPostLists.isNotEmpty
            ? StreamBuilder(
                stream: CombineLatestStream.list(storage.recentPostLists
                        .map((postList) => db.getTag(postList)))
                    .asBroadcastStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return Loading();
                  List<PostList> postLists = snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: postLists.length,
                      itemBuilder: (context, index) => GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            PostListWidget(
                                postList: postLists[index],
                                activeMoreOptions: false,
                                onTap: () => navigator.goPostList(context, postLists[index].id, postLists[index].author),),
                            IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  var newRecentPostLists =
                                      storage.recentPostLists;
                                  newRecentPostLists
                                      .remove(postLists[index].id);
                                  storage.recentPostLists = newRecentPostLists;
                                  setState(() {});
                                })
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text('No hay busquedas de listas recientes'),
              );
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: StreamBuilder(
          stream: db.getUser(db.userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (!snapshot.hasData) return Loading();
            User currentUser = snapshot.data;
            List<String> yourBlockedUsers = currentUser.blockedUsers;
            return SafeArea(
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
                            emptyWidget: Center(
                                child: Text('No se han encontrado resultados')),
                            hintText: 'Busca...',
                            iconActiveColor: Theme.of(context).primaryColor,
                            crossAxisSpacing: 20,
                            searchBarPadding:
                                EdgeInsets.only(left: 8, right: 8),
                            minimumChars: 1,
                            placeHolder: !isRecentsView
                                ? TendTagsStream()
                                : recentsView(),
                            onItemFound: (item, index) {
                              if (typeSearched == 'users') {
                                bool blocked =
                                    yourBlockedUsers.contains(item.id);
                                List<String> blockedUsers = item.blockedUsers;
                                bool youAreBlocked =
                                    blockedUsers.contains(db.userId);
                                return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: GestureDetector(
                                        child: UserRow(
                                      user: item,
                                      blocked: blocked,
                                      youAreBlocked: youAreBlocked,
                                      onTap: () {
                                        if (!storage.recentUsers
                                            .contains(item.id))
                                          storage.recentUsers =
                                              storage.recentUsers + [item.id];
                                        setState(() {});
                                        navigator.goUser(context, item.id);
                                      },
                                    )));
                              }

                              if (typeSearched == 'tags')
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TagWidget(
                                    tag: item,
                                    onTap: () {
                                      if (!storage.recentTags.contains(item.id))
                                        storage.recentTags =
                                            storage.recentTags + [item.id];
                                      setState(() {});
                                      navigator.goTag(context, item.id);
                                    },
                                  ),
                                );

                              if (typeSearched == 'postLists')
                                return StreamBuilder(
                                    stream:
                                        db.getPostList(item.author, item.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError)
                                        print(snapshot.error);
                                      if (!snapshot.hasData) return Loading();
                                      PostList postList = snapshot.data;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: PostListWidget(
                                          postList: postList,
                                          onTap: () {
                                            if (!storage.recentPostLists
                                                .contains(item))
                                              storage.recentPostLists =
                                                  storage.recentPostLists +
                                                      [item];
                                            setState(() {});
                                            navigator.goPostList(context, item.id, item.author);
                                          },
                                        ),
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
                                            onTap: (value) {
                                              if (value == 0)
                                                typeSearched = 'users';
                                              if (value == 1)
                                                typeSearched = 'tags';
                                              if (value == 2)
                                                typeSearched = 'postLists';
                                              searchBarController
                                                  .replayLastSearch();
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
            );
          }),
    );
  }
}

class TendTagsStream extends StatefulWidget {
  const TendTagsStream({
    Key key,
  }) : super(key: key);

  @override
  _TendTagsStreamState createState() => _TendTagsStreamState();
}

class _TendTagsStreamState extends State<TendTagsStream> {
  @override
  Widget build(BuildContext context) {
    

    return StreamBuilder(
        stream: db.getTendTags(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return Loading();
          List<Tag> tags = snapshot.data;
          if (tags.isEmpty)
            return Center(child: Text('No hay tags en tendencias'));
          return ListView.builder(
              itemCount: tags.length,
              itemBuilder: (context, index) {
                Tag tag = tags[index];
                List<String> postPaths = tag.posts;
                if (postPaths.isEmpty)
                  return Loading();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('${index + 1} - ',style:TextStyle(fontSize: 16)),
                          TagWidget(
                            tag: tag,
                            onTap: () => navigator.goTag(context, tag.id),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      StreamPosts(postPaths: postPaths)
                    ],
                  ),
                );
              });
        });
  }

}

class StreamPosts extends StatefulWidget {
  const StreamPosts({
    Key key,
    @required this.postPaths,
  }) : super(key: key);

  final List<String> postPaths;

  @override
  _StreamPostsState createState() => _StreamPostsState();
}

class _StreamPostsState extends State<StreamPosts> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {

    
        
    return StreamBuilder(
        stream: CombineLatestStream.list(widget.postPaths
            .map((postPath) => db.getPostByPath(postPath))).asBroadcastStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return Loading();
          List<Post> posts = snapshot.data;
          print(posts);
          return PostsCarousel(
            posts: posts,
            onTap: navigator.goPost,
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
