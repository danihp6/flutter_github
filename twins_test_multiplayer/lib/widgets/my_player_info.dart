import 'package:flutter/material.dart';
import 'package:twins_test_multiplayer/db.dart';
import 'package:twins_test_multiplayer/models/player.dart';

import 'my_loading.dart';

class MyPlayerInfo extends StatelessWidget {
  MyPlayerInfo(this.id);
  String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getPlayerById(id),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (!snapshot.hasData) return MyLoading('Jugador...');
        Player player = snapshot.data;
        return Container(
          color: Colors.greenAccent,
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
