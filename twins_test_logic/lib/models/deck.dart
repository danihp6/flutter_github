import 'package:twins_test_logic/dirImages.dart';

class Deck{
  String name;
  List<String> images;
  String image;

  Deck({this.image,this.name,this.images});
}

Deck animals=Deck(name:'Animales',images:[chamaleonImg,catImg,dogImg,elephantImg,giraffeImg,lionImg,rabbitImg,gorillaImg]);