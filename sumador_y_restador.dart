import 'package:flutter/material.dart';

void main() => runApp(MyApp());

int _count=0;

class MyApp extends StatefulWidget {
  _HomePage createState() => _HomePage();
}
  
  class _HomePage extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Sumador y Restador"),),
        body: Center(child:Container(
          width: 300,
          height: 100,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:[
                  RaisedButton(
                    child: Text("-1"),
                    onPressed: _decrease,
                  ),
                  RaisedButton(
                    child: Text("+1"),
                    onPressed: _increase             
                  )
                ]
              ),
              Text("$_count")
            ],
          )
        )),
      ),
    );
  }

  void _increase(){
    setState(() {
     _count++; 
    });
  }
  void _decrease(){
    setState(() {
     _count--; 
    });
  }
}
