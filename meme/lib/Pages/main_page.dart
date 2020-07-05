import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'tabs_page.dart';
import 'package:meme/Widgets/upload_button.dart';
import '../Controller/db.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  bool _isTabBarVisible = true;

  @override
  void initState() {
    
    configuration.scaffoldState =GlobalKey<ScaffoldState>();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: configuration.scaffoldState,
      body: TabsPage(),
      floatingActionButton: UploadButton(
        refresh: () {
          setState(() {});
        },
      ),
    );
  }
}
