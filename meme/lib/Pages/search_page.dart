import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
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
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
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

      if (tabController.index == 0) return db.userSearch(search);

      if (tabController.index == 1) return db.tagSearch(search);

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
            ? RecentsUsersStream()
            : Center(
                child: Text('No hay busquedas de usuarios recientes',
                    style: Theme.of(context).textTheme.bodyText1),
              );
      if (tabController.index == 1)
        return storage.recentTags.isNotEmpty
            ? RecentsTagsStream()
            : Center(
                child: Text('No hay busquedas de tags recientes',
                    style: Theme.of(context).textTheme.bodyText1),
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
                            textStyle: Theme.of(context).textTheme.bodyText1,
                            searchBarStyle: SearchBarStyle(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                            ),
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
                                : Icon(
                                    Icons.search,
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
                                  ),
                            emptyWidget: Center(
                                child: Text('No se han encontrado resultados',
                                    style:
                                        Theme.of(context).textTheme.bodyText1)),
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
                                return StreamBuilder(
                                    stream: db.getUser(item),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError)
                                        print(snapshot.error);
                                      if (!snapshot.hasData) return Loading();
                                      User user = snapshot.data;
                                      bool blocked =
                                          yourBlockedUsers.contains(user.id);
                                      List<String> blockedUsers =
                                          user.blockedUsers;
                                      bool youAreBlocked =
                                          blockedUsers.contains(db.userId);
                                      return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8,bottom: 4),
                                          child: GestureDetector(
                                              child: SizedBox(
                                            height: 50,
                                            child: UserRow(
                                              user: user,
                                              blocked: blocked,
                                              youAreBlocked: youAreBlocked,
                                              onTap: () {
                                                if (!storage.recentUsers
                                                    .contains(user.id))
                                                  storage.recentUsers =
                                                      storage.recentUsers +
                                                          [user.id];
                                                setState(() {});
                                                navigator.goUser(
                                                    context, user.id);
                                              },
                                            ),
                                          )));
                                    });
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

                              
                            },
                            header: isRecentsView
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        child: TabBar(
                                            controller: tabController,
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(fontSize: 16),
                                            onTap: (value) {
                                              if (value == 0)
                                                typeSearched = 'users';
                                              if (value == 1)
                                                typeSearched = 'tags';
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


class RecentsTagsStream extends StatefulWidget {
  const RecentsTagsStream({
    Key key,
  }) : super(key: key);

  @override
  _RecentsTagsStreamState createState() => _RecentsTagsStreamState();
}

class _RecentsTagsStreamState extends State<RecentsTagsStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CombineLatestStream.list(
          storage.recentTags.map((tag) => db.getTag(tag))).asBroadcastStream(),
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
    );
  }
}

class RecentsUsersStream extends StatefulWidget {
  const RecentsUsersStream({
    Key key,
  }) : super(key: key);

  @override
  _RecentsUsersStreamState createState() => _RecentsUsersStreamState();
}

class _RecentsUsersStreamState extends State<RecentsUsersStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
                      SizedBox(
                          height: 40, child: UserAvatar(user: users[index])),
                      SizedBox(width: 10),
                      Text(users[index].userName,
                          style: Theme.of(context).textTheme.bodyText1),
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
            return Center(
                child: Text('No hay tags en tendencias',
                    style: Theme.of(context).textTheme.bodyText1));
          return ListView.builder(
              itemCount: tags.length,
              itemBuilder: (context, index) {
                Tag tag = tags[index];
                if (tag.posts.isEmpty) return Loading();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('${index + 1} - ',
                              style: Theme.of(context).textTheme.bodyText1),
                          TagWidget(
                            tag: tag,
                            onTap: () => navigator.goTag(context, tag.id),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      StreamPosts(tagId:tag.id)
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
    @required this.tagId,
  }) : super(key: key);

  final String tagId;

  @override
  _StreamPostsState createState() => _StreamPostsState();
}

class _StreamPostsState extends State<StreamPosts>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        // stream: CombineLatestStream.list(
        //         widget.postPaths.map((postPath) => db.getPostByPath(postPath)))
        //     .asBroadcastStream(),
        stream: db.getTagGroupPost(widget.tagId),
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
