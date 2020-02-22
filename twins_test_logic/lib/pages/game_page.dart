import 'package:flutter/material.dart';
import 'package:twins_test_logic/models/game.dart';
import 'package:twins_test_logic/models/single_game.dart';
import 'package:twins_test_logic/models/token.dart';
import 'package:twins_test_logic/widgets/token_widget.dart';

class GamePage extends StatefulWidget {
  GamePage(this.game);
  SingleGame game;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game')),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                  itemCount: widget.game.board.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TokenWidget(widget.game.board[index],getGame,refresh),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Game getGame()=>widget.game;

  void refresh()=>setState(() {
      
    });
}
