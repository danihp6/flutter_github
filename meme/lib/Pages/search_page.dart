import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post.dart';
import '../Controller/db.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> search(String search) {
      search = search.toLowerCase();
      print(search);
      if (search[0] == '@') return userSearch(search.substring(1));
      if (search[0] == '#') return postSearch(search.substring(1));
      if (search[0] == '&') return postListSearch(search.substring(1));
      if (tabController.index == 0) return userSearch(search);
      if (tabController.index == 1) return postSearch(search);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SearchBar(
                    onSearch: search,
                    emptyWidget: Center(child:Text('No se han encontrado resultados')),
                    hintText: 'Busca...',
                    iconActiveColor: Colors.deepOrange,
                    crossAxisSpacing: 20,
                    searchBarPadding: EdgeInsets.only(left:8,right:8),
                    minimumChars: 1,
                    onItemFound: (item, index) {
                      if (item is User)
                        return Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(item.getAvatar()),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(item.getUserName(),style: TextStyle(fontSize: 16),)
                            ],
                          ),
                        );
                      return StreamBuilder(
                          stream: getPost(item),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            if (!snapshot.hasData) return Loading();
                            Post post = snapshot.data;
                            print(post.getId());
                            return PostWidget(post: post);
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
                              tabs: [
                                Tab(
                                  text: 'Usuarios',
                                ),
                                Tab(
                                  text: 'Publicaciones',
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
