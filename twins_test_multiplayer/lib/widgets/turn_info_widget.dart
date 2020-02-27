import 'package:flutter/material.dart';
import 'package:twins_test_multiplayer/db.dart';
import 'package:twins_test_multiplayer/models/turn.dart';

import 'my_loading.dart';

class TurnInfo extends StatelessWidget {
  TurnInfo(this.gameId);
  String gameId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream:getTurns(gameId),
      builder: (context, snapshot) {
        if (snapshot.hasError)
            return Center(child: Text(snapshot.error.toString()));
          if (!snapshot.hasData) return MyLoading('Cargando...');
          List<Turn> turns=snapshot.data;
        return Container(
          child: Row(
            children: <Widget>[
              Text(turns.last.turn.toString()),
              Text(turns.last.timer.toString())
            ],
          ),
        );
      }
    );
  }
}