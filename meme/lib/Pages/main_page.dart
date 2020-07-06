import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'tabs_page.dart';
import 'package:meme/Widgets/upload_button.dart';
import '../Controller/db.dart';

class MainPage extends StatelessWidget {

  GlobalKey<ScaffoldState> scaffoldState= GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    configuration.mainScaffoldState = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: configuration.mainScaffoldState,
      body: TabsPage(
      ),
      
    );
  }
}
