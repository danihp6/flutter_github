import 'package:twins_test_logic/models/player.dart';
import 'package:twins_test_logic/models/token.dart';

const int NOT_STARTED = 0;
const int IN_PROGRESS = 1;
const int FINISHED = 2;
const int CANCELLED = 3;

class Game{
  String id;
  List<Token> board;
  int state;
  DateTime datetime;
  List<Player> players;

  Game({this.id, this.board, this.datetime, this.state,this.players});
}