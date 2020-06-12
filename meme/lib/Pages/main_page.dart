import 'package:flutter/material.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/favourite_page.dart';
import 'package:meme/Widgets/floating_buttons.dart';

class MainPage extends StatefulWidget {
  User user;
  MainPage({this.user});
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
            FavouritePage(user:widget.user)
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
