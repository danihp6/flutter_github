import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/Tag.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/post_list_page.dart';
import 'package:meme/Widgets/follow_button.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post.dart';
import 'package:meme/Widgets/post_list.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_avatar.dart';
import '../Controller/db.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  SearchBarController searchBarController;
  String typeSearched = 'users';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    searchBarController = SearchBarController();
  }

  @override
  void dispose() {
    tabController.dispose();
    searchBarController = null;
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

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: SearchBar(
                    onSearch: search,
                    searchBarController: searchBarController,
                    emptyWidget:
                        Center(child: Text('No se han encontrado resultados')),
                    hintText: 'Busca...',
                    iconActiveColor: Colors.deepOrange,
                    crossAxisSpacing: 20,
                    searchBarPadding: EdgeInsets.only(left: 8, right: 8),
                    minimumChars: 1,
                    onItemFound: (item, index) {
                      if (typeSearched == 'users')
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0,right:8),
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
                        return StreamBuilder(
                            stream: db.getTag(item),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              if (!snapshot.hasData) return Loading();
                              Tag tag = snapshot.data;
                              print(tag);
                              return Text('#'+tag.name,style: TextStyle(fontSize: 16),);
                            });
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
                    header: Column(
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
                                if (value == 2) typeSearched = 'postLists';
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
                    ))),
          ],
        ),
      ),
    );
  }
}
