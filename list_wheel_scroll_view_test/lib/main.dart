import 'package:flutter/material.dart';
import 'package:list_wheel_scroll_view_test/wheel_element.dart';
import 'package:list_wheel_scroll_view_test/world_page.dart';

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
      routes: {'/': (_) => MyHomePage(), '/world': (_) => WorldPage()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color selectedColor = Colors.blue;
  int selectedWorld = 0;
  List<Color> colors = [Colors.blue,Colors.blue[200],Colors.blue[200],Colors.blue[200],Colors.blue[200],Colors.blue[200],Colors.blue[200],Colors.blue[200],Colors.blue[200],Colors.blue[200]];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20,),
        child: ListWheelScrollView(
          children: List<Widget>.generate(10, (index) => WheelElement(colors[index], index)),
          itemExtent: 150,
          diameterRatio: 1.5,
          physics: FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            setState(() {
              selectedWorld=index;
              if(index==0)colors[1]=Colors.blue[200];
              else if(index==colors.length-1)colors[colors.length-2]=Colors.blue[200];
              else {
                colors[index-1]=Colors.blue[200];
                colors[index+1]=Colors.blue[200];
              }
              colors[index]=selectedColor;
            });
            
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('GO',style: TextStyle(fontSize: 20)),
         onPressed: () =>Navigator.of(context).pushNamed('/world',arguments:selectedWorld),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
