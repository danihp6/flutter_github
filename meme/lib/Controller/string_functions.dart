List<String> generateKeyWords(String string){
  List<String> keyWords = [];
  for (var i = 0; i <= string.length; i++) {
    keyWords.add(string.substring(0,i));
  }
  return keyWords;
}


int startIndexWordAtPosition(String string,int position){
  if(string[position] == ' ') return -1;
  int res = position ;
  while(res > 0 && string[res - 1] != ' '){
    res--;
  }
  return res ;
}

String nextWord(String string){
  int i = 0;
  while(i<string.length && string[i]!=' ') {
    i++;
  }
  return string.substring(0,i);
}

List<String> wordsStartWith(String string,String letter){
  List<String> words = [];
  List<String> allWords = string.split(' ');
  for (var word in allWords) {
    if(!words.contains(word) && word.startsWith(letter)) words.add(word);
  }
  return words;
}

int restOffWord (String string,int position){
  int i = 0;
  while(i<string.length && string[position]!= ' '){
    print(string[i]);
    i++;
  }
  print(i);
  return i;
}