import 'package:flutter/material.dart';
import 'package:twins_test_logic/models/game.dart';
import 'package:twins_test_logic/widgets/token_widget.dart';

class GamePage extends StatelessWidget {
  GamePage(this.game);
  Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Game')),
          body: Container(
        child: Column(
          
          children: <Widget>[
            Expanded(
                          child: GridView.builder(
                itemCount: game.board.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), 
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TokenWidget(game.board[index]),
                );
              }
              ),
            ),
          ],
        ),
      ),
    );
  }
}