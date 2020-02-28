import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 500,
          child: FlipCard(
            direction: FlipDirection.VERTICAL,
            flipOnTouch: true,
            front: Container(
              child: Image.asset('assets/card_front.png'),
            ),
            back: Container(
              child: Image.asset('assets/card_back.png'),
            ),
          ),
        ),
      ),
    );
  }
}
