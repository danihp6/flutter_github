import 'package:flutter/material.dart';
import 'package:meme/Pages/favourite_page.dart';
import 'package:meme/Widgets/floating_buttons.dart';
import 'package:meme/Widgets/user_info.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isTabBarVisible = true;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            FavouritePage()
            ]),
            floatingActionButton: FloatingButtons(refresh: (){setState(() {});},),
        bottomNavigationBar: _isTabBarVisible?Container(
          color: Colors.grey[300],
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.star,color: Colors.black,size: 30,),)
            ]),
        ):SizedBox(),
      ),
    );
  }
}
