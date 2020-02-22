import 'package:flutter/material.dart';
import 'package:twins_test_logic/models/game.dart';
import 'package:twins_test_logic/models/single_game.dart';
import 'package:twins_test_logic/models/token.dart';

class TokenWidget extends StatefulWidget {
  TokenWidget(this.token, this.getGame, this.setStateParent);
  Token token;
  Function getGame;
  Function setStateParent;

  @override
  _TokenWidgetState createState() => _TokenWidgetState();
}

class _TokenWidgetState extends State<TokenWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: widget.token.getState == PAIRED
            ? Colors.yellowAccent
            : Colors.greenAccent,
        child:
            widget.token.getState == SHOWED || widget.token.getState == PAIRED
                ? Image.asset(widget.token.getImage, fit: BoxFit.cover)
                : Container(),
      ),
      onTap: tapToken,
    );
  }

  void tapToken() {
    SingleGame game = widget.getGame();
    if (widget.token.getState == HIDED && game.getTurnState != STOPED) {
      game.setTurnState=STOPED;
      setState(() {
        widget.token.show();
      });
      if (game.turnState == FIRST_TOKEN)
        game.setTurnState = SECOND_TOKEN;
      else {
        List<Token> showedTokens =
            game.board.where((token) => token.getState == SHOWED).toList();
        if (arePair(showedTokens)) {
          showedTokens.forEach((token) => token.pair());
          widget.setStateParent();

          game.twins++;
        } else {
          
            showedTokens.forEach((token) => token.hide());
            widget.setStateParent();
        }
        game.setTurnState = FIRST_TOKEN;
      }
    }
    
    print(game);
  }
}

Future sleep(int seconds){
  return Future.delayed(Duration(seconds: 1)).then((_) => null);
}