import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/web_scrapping.dart';
import 'package:meme/Pages/home_page.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/floating_buttons.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isTabBarVisible = true;

  @override
  void initState() {
    super.initState();
    initiate();
  }

  @override
  Widget build(BuildContext context) {
    String userId = configuration.getUserId();
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
          // HomePage(userId:userId),
          UserPage(
            userId: userId,
          ),
        ]),
        floatingActionButton: FloatingButtons(
          refresh: () {
            setState(() {});
          },
        ),
        bottomNavigationBar: _isTabBarVisible
            ? Container(
                child: TabBar(
                  tabs: [
                    // Tab(
                    //   icon: Icon(
                    //     Icons.home,
                    //     size: 30,
                    //   ),
                    // ),
                    Tab(
                      icon: Icon(
                        Icons.person,
                        size: 40,
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
