import 'package:flutter/material.dart';
import 'package:meme/Controller/push_notification_provider.dart';
import 'package:meme/Pages/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PushNotificationProvider pushProvider;

  @override
  void initState() {
    super.initState();
    pushProvider = PushNotificationProvider();
    pushProvider.initNotifications();

    pushProvider.message.listen((arg) {
      print('ARGUMENTO DEL PUSH');

    });
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
