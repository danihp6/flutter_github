import 'package:flutter/material.dart';
import 'package:meme/Pages/tabs_page.dart';

class MainPage extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: TabsPage(
        scaffoldState:scaffoldState
      ),
    );
  }
}