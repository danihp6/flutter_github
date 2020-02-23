import 'package:flutter/material.dart';
import 'package:twins_test_multiplayer/models/game.dart';
import 'package:twins_test_multiplayer/models/player.dart';
import 'package:twins_test_multiplayer/pages/game_page.dart';
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
            if (game.players.length == 2) return GamePage(game.id);
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


