import 'package:flutter/material.dart';
import 'package:twins_test_logic/pages/game_page.dart';
import 'package:twins_test_logic/models/game.dart';
import 'package:twins_test_logic/models/token.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/':(context)=>GamePage(Game(board: animalsBoard))
      },
    );
  }
}