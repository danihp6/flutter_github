import 'package:twins_test_logic/models/deck.dart';
import 'package:twins_test_logic/models/token.dart';

const int NOT_STARTED = 0;
const int IN_PROGRESS = 1;
const int FINISHED = 2;
const int CANCELLED = 3;

class Game {
  String id;
  List<Token> board;
  Deck deck;
  int state;
  int twins;

  Game({this.id,this.state=IN_PROGRESS,this.deck,this.board,this.twins=0});

  Game.run({this.id,this.state=IN_PROGRESS,this.deck,this.twins=0}){
    board=boardByDeck(deck);
  }

  List<Token> showedTokens()=>board.where((token) => token.getState==SHOWED).toList();

  @override
  String toString() {
    return 'id:$id board: $board deck:$deck state:$state twins:$twins';
  }
}

List<Token> boardByDeck(Deck deck) {
  int id = 0;
  List<Token> board = List<Token>();
  deck.images.map((image) {
    board.addAll([Token(id: id, image: image), Token(id: id, image: image)]);
    id++;
  }).toList();
  board.shuffle();
  return board;
}
