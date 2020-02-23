import 'package:flutter/material.dart';
import 'package:twins_test_logic/models/game.dart';
import 'package:twins_test_logic/models/single_game.dart';
import 'package:twins_test_logic/models/token.dart';
import 'package:twins_test_logic/widgets/token_widget.dart';
import 'package:twins_test_logic/widgets/clock_widget.dart';

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
            Container(
              width: 80,
              height: 80,
              child: ClockWidget(
                start: 60,
                duration: 60,
                onDone: (){
                  print('fin');
                },
                )
              ),
            Text('Parejas: ${widget.game.twins.toString()}/${widget.game.board.length~/2}',style:TextStyle(
              fontSize: 20
            )),
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
