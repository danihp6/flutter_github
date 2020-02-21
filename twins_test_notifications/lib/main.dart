import 'package:flutter/material.dart';
import 'package:twins_test_notifications/push_notification_provider.dart';

import 'home_page.dart';
import 'message_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigationKey=GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    final pushProvider = PushNotificationProvider();
    pushProvider.initNotifications();

    pushProvider.message.listen((arg) { 
      // Navigator.pushNamed(context, '/message');
      print('ARGUMENTO DEL PUSH');
      print(arg);

      navigationKey.currentState.pushNamed('/message',arguments: arg);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigationKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/':(context)=>HomePage(),
        '/message':(context)=>MessagePage()
      },
    );
  }
}
