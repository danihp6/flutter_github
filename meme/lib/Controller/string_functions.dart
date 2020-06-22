List<String> generateKeyWords(String string){
  List<String> keyWords = [];
  for (var i = 0; i < string.length; i++) {
    keyWords.add(string.substring(0,i));
  }
  return keyWords;
}