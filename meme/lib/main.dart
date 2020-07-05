import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meme/Controller/configuration.dart';
import 'package:meme/Controller/push_notification_provider.dart';
import 'package:meme/Pages/post_page.dart';
import 'package:meme/Pages/root_page.dart';
import 'package:meme/Pages/settings_page.dart';
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
    configuration.navigatorKey =
        GlobalKey<NavigatorState>();
    pushProvider.initNotifications();
    storage.initStorage();
    dynamicLinks.initDynamicLinks((Uri link) {
      Map linkParameters = link.queryParameters;
      
      configuration.navigatorKey.currentState
          .push(SlideLeftRoute(page: PostPage(authorId: linkParameters['author'],postId: linkParameters['id'],)));
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
      navigatorKey: configuration.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepOrangeAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Color(0xFF323232)
        )
      ),
      home: RootPage(),
    );
  }
}
