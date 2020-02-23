import 'package:flutter/material.dart';
import 'package:twins_test_multiplayer/models/game.dart';
import 'package:twins_test_multiplayer/widgets/my_loading.dart';
import 'package:twins_test_multiplayer/widgets/my_player_info.dart';

import '../db.dart';

class GamePage extends StatelessWidget {
  GamePage(this.id);
  String id;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: StreamBuilder(
          stream: getGameById(id),
          builder: (context, snapshot) {
            if (snapshot.hasError)
            return Center(child: Text(snapshot.error.toString()));
          if (!snapshot.hasData) return MyLoading('Partida encontrada');
          Game game=snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(game.timer.toString()),
                Padding(
                  padding: const EdgeInsets.only(top:10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      MyPlayerInfo(game.players.first),
                      Text('VS'),
                      MyPlayerInfo(game.players[1]),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top:10),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemCount: game.list.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.greenAccent,
                              child:
                                  Center(child: Text(game.list[index].toString())),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            );
          }),
    );
  }
}