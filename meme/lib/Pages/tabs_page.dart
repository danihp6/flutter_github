import 'package:flutter/material.dart';
import 'package:meme/Controller/configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Pages/home_page.dart';
import 'package:meme/Pages/notifications_page.dart';
import 'package:meme/Pages/search_page.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/upload_button.dart';
import 'my_user_page.dart';

class TabsPage extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldState;
  TabsPage({@required this.scaffoldState});
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  
  

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: UploadButton(
        refresh: () {
          setState(() {});
        },
      ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            HomePage(userId: db.userId,scaffoldState:widget.scaffoldState),
            SearchPage(),
            NotificationsPage(
              userId: db.userId,
            ),
            MyUserPage(scaffoldState: widget.scaffoldState,)
          ],
        ),
        bottomNavigationBar: Container(
          child: TabBar(
            controller: tabController,
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
            
            indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 0)),
          ),
        ));
  }
}
