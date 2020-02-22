import 'package:twins_test_logic/dirImages.dart';

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

  void compareCards(Token token) {
    if (this.isPar(token)) {
      this.pair();
      token.pair();
    } else {
      Future.delayed(const Duration(seconds: 2));
      this.hide();
      token.hide();
    }
  }



}
  Token chamaleon = Token(image: chamaleonImg);
 Token rabbit = Token(image: rabbitImg);
  Token elephant = Token(image: elephantImg);
  Token cat = Token(image: catImg);
  Token gorilla = Token(image: gorillaImg);
  Token giraffe = Token(image: giraffeImg);
  Token lion = Token(image: lionImg);
  Token dog = Token(image: dogImg);

  List<Token> animalsBoard=[chamaleon,rabbit,elephant,cat,gorilla,giraffe,lion,dog];