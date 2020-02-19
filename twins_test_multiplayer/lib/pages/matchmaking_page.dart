import 'package:flutter/material.dart';
import 'package:twins_test_multiplayer/models/game.dart';
import 'package:twins_test_multiplayer/models/player.dart';
import 'package:twins_test_multiplayer/widgets/my_loading.dart';

import '../db.dart';


class MatchmakingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Player player = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        child: matchmaking(player),
      ),
    );
  }
}

Widget matchmaking(Player player) {
  return StreamBuilder(
      stream: getGamesOrderByDatetime(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (!snapshot.hasData) return MyLoading('Buscando partida');
        List<Game> games = snapshot.data;
        print(games.toString());
        for (int i = 0; i < games.length; i++) {
          Game game = games[i];
          if (game.players.contains(player.id)) {
            if (game.players.length == 2)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${game.players.first} VS ${game.players[1]}'),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemCount: game.list.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.greenAccent,
                              child: Center(
                                  child: Text(game.list[index].toString())),
                            ),
                          );
                        }),
                  ),
                ],
              );
            return MyLoading('Esperando jugadores');
          }
          if (game.players.length < 2) {
            joinPlayerToGame(game.id, player.id);
            return MyLoading('Uniendose a partida');
          }
        }
        newGame(Game.fourxfour());
        return MyLoading('creando partida');
      });
}
