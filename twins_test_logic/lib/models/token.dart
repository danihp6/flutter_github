import 'package:twins_test_logic/dirImages.dart';
import 'package:twins_test_logic/models/deck.dart';

const int HIDED = 0;
const int SHOWED = 1;
const int PAIRED = 2;

class Token {
  int id;
  String image;
  int state;

  Token({this.id, this.image, this.state = HIDED});

  int get getState => state;

  int get getId => id;

  String get getImage => image;

  void hide() => state = HIDED;

  void show() => state = SHOWED;

  void pair() => state = PAIRED;

  bool isPar(Token token) => this.id == token.id;

  @override
  String toString() {
    return 'id: $id image:$image state:$state';
  }
}

bool arePair(List<Token> tokens) {
  Token token1=tokens.first;
  Token token2=tokens[1];
    if (token1.isPar(token2)) {
      return true;
    } else {
      return false;
    }
  }

