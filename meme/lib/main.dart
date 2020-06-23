import 'package:flutter/material.dart';
import 'package:meme/Controller/local_storage.dart';
import 'package:meme/Controller/push_notification_provider.dart';
import 'package:meme/Pages/camera_page.dart';
import 'package:meme/Pages/main_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

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
    pushProvider.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}
