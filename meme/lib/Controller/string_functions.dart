
import 'dart:math';

List<String> generateKeyWords(String string){
  List<String> keyWords = [];
  for (var i = 1; i <= string.length; i++) {
    keyWords.add(string.substring(0,i));
  }
  return keyWords;
}


int startIndexWordAtPosition(String string,int position){
  int res = position;
  print(string[position] == ' ');
  while(res <=)
  for (var i = position - 1; i >= 0 && string[i] != ' '; i--) {
    res--;
  }
  return res;
}