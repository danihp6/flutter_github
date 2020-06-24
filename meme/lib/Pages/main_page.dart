import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/web_scrapping.dart';
import 'package:meme/Pages/home_page.dart';
import 'package:meme/Pages/notifications_page.dart';
import 'package:meme/Pages/search_page.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/upload_button.dart';
import '../Controller/db.dart';

class MainPage extends StatefulWidget {
  Function refresh;
  MainPage({this.refresh});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isTabBarVisible = true;


  @override
  Widget build(BuildContext context) {
    String userId = db.userId;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
          HomePage(userId:userId),
          SearchPage(),
          NotificationsPage(userId: userId,),
          UserPage(
            userId: userId,
            activeAppBar: false,
            refresh:widget.refresh
          ),
        ]),
        floatingActionButton: UploadButton(
          refresh: () {
            setState(() {});
          },
        ),
        bottomNavigationBar: _isTabBarVisible
            ? Container(
                child: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.home,
                        size: 30,
                      ),
                    ),
                                        Tab(
                      icon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.notifications,
                        size: 30,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    )
                  ],
                  labelColor: Colors.deepOrange,
                  unselectedLabelColor: Colors.black,
                  indicator:
                      UnderlineTabIndicator(borderSide: BorderSide(width: 0)),
                ),
              )
            : SizedBox(),
      ),
    );
  }
}
