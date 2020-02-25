import 'package:flutter/material.dart';
import 'package:twins_test_multiplayer/db.dart';
import 'package:twins_test_multiplayer/models/player.dart';

import 'my_loading.dart';

class MyPlayerInfo extends StatefulWidget {
  MyPlayerInfo({@required this.id,this.color=Colors.greenAccent});
  String id;
  Color color;

  @override
  _MyPlayerInfoState createState() => _MyPlayerInfoState();
}

class _MyPlayerInfoState extends State<MyPlayerInfo> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getPlayerById(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (!snapshot.hasData) return MyLoading('Jugador...');
        Player player = snapshot.data;
        return Container(
          color: widget.color,
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(player.name)
            ],
          ),
        );
      }
    );
  }
}


