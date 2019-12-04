import 'package:flutter/material.dart';

void main() => runApp(MyApp());

String _description="hola";

class MyApp extends StatefulWidget {
  _HomePage createState()=> _HomePage();
}

class _HomePage extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(title:Text("Mercadona")),
  
        body:Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top:10,bottom: 10,left: 25,right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/mercadona.jpg",
                    scale:3,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children:[
                      IconButton(
                        icon:Icon(
                          Icons.local_phone,
                          color: Colors.blue[300],
                          size: 50,
                        ),
                        onPressed: _changeDescription("648518361"),
                      )
                    ]
                  ),
                  Column(
                    children:[
                      IconButton(
                        icon:Icon(
                          Icons.location_on,
                          color: Colors.blue[300],
                          size:50
                        ),
                        onPressed: _changeDescription("Carrer Alacant, s/n, 46134 Foios, VLC"),
                      )
                    ]
                  ),
                  Column(
                    children:[
                      IconButton(
                        icon:Icon(
                          Icons.calendar_today,
                          color:Colors.blue[300],
                          size:50
                        ),
                        onPressed: _changeDescription("Martes     9:00-21:30"),
                      )
                    ]
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _description,
                    style: TextStyle(
                      fontSize: 20
                    ),
                    )
                ],
              ),
            ],
          ),
        )
      )
    );
  }

  Function _changeDescription(String text){
    return()=>
    setState(() {
      _description=text;
    });
  }

  
}
