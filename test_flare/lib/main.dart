import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool jumping=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          setState(() {
            jumping?jumping=false:jumping=true;
          });
              
            },
        child: Container(
          width: 300,
          height: 300,
          child: FlareActor('assets/minion.flr',
          callback: (value)=>print(value),
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: jumping?'Jump':'Dance',
              
              ),

        ),
      ),
    );
  }
}
