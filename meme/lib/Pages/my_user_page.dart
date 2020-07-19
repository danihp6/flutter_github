import 'package:flutter/material.dart';
import 'package:meme/Controller/auth.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/account_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post_list_new_button.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_page_header.dart';
import 'user_page.dart';

import 'contact_page.dart';

class MyUserPage extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldState;
  MyUserPage({this.scaffoldState});

  @override
  _MyUserPageState createState() => _MyUserPageState();
}

class _MyUserPageState extends State<MyUserPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  GlobalKey<ScaffoldState> _scaffoldState;

  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this);
    if(widget.scaffoldState == null)_scaffoldState = GlobalKey<ScaffoldState>();
    else _scaffoldState = widget.scaffoldState;

    super.initState();
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
                              onPressed: () => navigator.goContact(context),
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
                              onPressed: () => navigator.goAccount(context),
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
                        scaffoldState: _scaffoldState,
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
                                PostsStream(
                                  scaffoldState: _scaffoldState,
                                  userId: user.id,
                                ),
                                favourites.isNotEmpty
                                    ? FavouritesStream(
                                        favourites: favourites,
                                        scaffoldState: _scaffoldState)
                                    : Center(
                                        child: Text('Usuario sin favoritos')),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      PostListNewButton(),
                                      Expanded(
                                        child: PostListsStream(
                                          userId: user.id,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ));
            }));
  }
}
