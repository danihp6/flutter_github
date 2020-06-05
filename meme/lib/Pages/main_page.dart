import 'package:flutter/material.dart';
import 'package:meme/Pages/favourite_page.dart';
import 'package:meme/Widgets/floating_buttons.dart';
import 'package:meme/Widgets/user_info.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: TabBarView(
          children: [
            FavouritePage()
            ]),
            floatingActionButton: FloatingButtons(refresh: (){setState(() {});},),
        bottomNavigationBar: Container(
          color: Colors.grey[300],
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.star,color: Colors.black,size: 30,),)
            ]),
        ),
      ),
    );
  }
}
