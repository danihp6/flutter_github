import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meme/Controller/configuration.dart';
import 'package:meme/Controller/push_notification_provider.dart';
import 'package:meme/Pages/post_page.dart';
import 'package:meme/Pages/root_page.dart';
import 'package:meme/Pages/settings_page.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

import 'Controller/gallery.dart';
import 'Controller/local_storage.dart';
import 'Controller/dynamic_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    configuration.mainNavigatorKey = GlobalKey<NavigatorState>();
    pushProvider.initNotifications();
    storage.initStorage();
    dynamicLinks.initDynamicLinks((Uri link) {
      Map linkParameters = link.queryParameters;
      print('-----------------------------------');
      String type = linkParameters['type'];
      if(type == 'post')
      configuration.mainNavigatorKey.currentState.push(SlideLeftRoute(
          page: PostPage(
        authorId: linkParameters['author'],
        postId: linkParameters['id'],
      )));
      if(type == 'user')
      configuration.mainNavigatorKey.currentState.push(SlideLeftRoute(
          page: UserPage(
        userId: linkParameters['id'],
      )));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: configuration.mainNavigatorKey,
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepOrangeAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Color(0xFF323232),
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top:Radius.circular(10)),
            ),
          )),
      home: RootPage(),
    );
  }
}
