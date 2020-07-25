import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meme/Controller/configuration.dart';
import 'package:meme/Controller/downloader.dart';
import 'package:meme/Controller/push_notification_provider.dart';
import 'package:meme/Pages/post_page.dart';
import 'package:meme/Pages/root_page.dart';
import 'package:meme/Pages/settings_page.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/theme_changer.dart';
import 'package:provider/provider.dart';

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
    WidgetsFlutterBinding.ensureInitialized();
    downloader.initialize();
    dynamicLinks.initDynamicLinks((Uri link) {
      Map linkParameters = link.queryParameters;
      print('-----------------------------------');
      String type = linkParameters['type'];
      if (type == 'post')
        configuration.mainNavigatorKey.currentState.push(SlideLeftRoute(
            page: PostPage(
          authorId: linkParameters['author'],
          postId: linkParameters['id'],
        )));
      if (type == 'user')
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
    return ChangeNotifierProvider<ThemeChanger>(
      create: (context) => ThemeChanger(ThemeMode.light),
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      themeMode: theme.themeMode,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: configuration.mainNavigatorKey,
      theme: lightTheme,
      home: RootPage(),
    );
  }

  final lightTheme = ThemeData(
      primaryColor: Colors.deepOrange,
      accentColor: Colors.deepOrangeAccent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      unselectedWidgetColor: Colors.black,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.red),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
      ),
      sliderTheme: SliderThemeData(
          valueIndicatorColor: Colors.white, thumbColor: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.black, fontSize: 18),
        headline1: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Color(0xFF323232),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.deepOrange,
        unselectedLabelColor: Colors.black,
      ));

  final darkTheme = ThemeData(
      primaryColor: Colors.deepOrange,
      accentColor: Colors.deepOrangeAccent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      unselectedWidgetColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(color: Colors.red),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
      sliderTheme: SliderThemeData(
          valueIndicatorColor: Colors.black, thumbColor: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.white, fontSize: 18),
        headline1: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Color(0xFF323232),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.deepOrange,
        unselectedLabelColor: Colors.white,
      ));
}
