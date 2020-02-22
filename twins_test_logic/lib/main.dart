import 'package:flutter/material.dart';
import 'package:twins_test_logic/models/deck.dart';
import 'package:twins_test_logic/models/single_game.dart';
import 'package:twins_test_logic/pages/game_page.dart';
import 'package:twins_test_logic/models/game.dart';
import 'models/deck.dart';

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
        '/':(context)=>GamePage(SingleGame.run(deck: animals))
      },
    );
  }
}