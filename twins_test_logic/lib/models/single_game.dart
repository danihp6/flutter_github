import 'deck.dart';
import 'game.dart';

import 'player.dart';
import 'token.dart';

const int STOPED = 0;
const int FIRST_TOKEN = 1;
const int SECOND_TOKEN = 2;

class SingleGame extends Game {
  Player player;
  int turnState;

  SingleGame(
      {this.turnState = FIRST_TOKEN,
      this.player,
      String id,
      List<Token> board,
      Deck deck,
      int state = IN_PROGRESS,
      int twins = 0})
      : super(id: id, board: board, deck: deck, state: state, twins: twins);

  SingleGame.run(
      {this.turnState = FIRST_TOKEN,
      this.player,
      String id,
      Deck deck,
      int state = IN_PROGRESS,
      int twins = 0})
      : super(
            id: id,
            board: boardByDeck(deck),
            deck: deck,
            state: state,
            twins: twins);
  int get getTurnState => turnState;

  set setTurnState(int newState) => turnState = newState;
}
