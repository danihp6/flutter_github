import 'package:cloud_firestore/cloud_firestore.dart';

const int NOT_STARTED = 0;
const int IN_PROGRESS = 1;
const int FINISHED = 2;
const int CANCELLED = 3;

class Game {
  String id;
  List<int> list;
  int state;
  DateTime datetime;
  List<String> players;
  int timer;

  Game({this.id, this.list, this.datetime, this.state,this.players,this.timer});

  Game.fourxfour() {
    list = pairsRandomNumbers(16);
    players=List<String>();
    datetime = DateTime.now();
    state = NOT_STARTED;
    timer=0;
  }

  factory Game.fromFirestore(DocumentSnapshot doc) {
    return Game(
        id: doc.documentID,
        list: List<int>.from(doc.data['list']),
        datetime: (doc.data['datetime'] as Timestamp).toDate(),
        state: doc.data['state'],
        players:List<String>.from(doc.data['players']),
        timer:doc.data['timer']
        );
  }

Map<String, dynamic> toJson() =>{
        'list': list,
        'datetime': datetime,
        'state': state,
        'players':players,
        'timer':timer
  };

  @override
  String toString() {
    return 'id:$id,state:$state,players:$players,list:${list.toString()},datetime:$datetime,timer:$timer';
  }
}

List<Game> toGameList(QuerySnapshot query) {
  return query.documents.map((doc) => Game.fromFirestore(doc)).toList();
}

Game toGame(DocumentSnapshot document) {
  Game game = Game.fromFirestore(document);
  print(game.toString());
  return Game.fromFirestore(document);
}

List<int> intList(int max) {
  List<int> list = List<int>();
  for (var i = 0; i < max; i++) {
    list.add(i);
  }
  return list;
}

List<int> pairsRandomNumbers(int length) {
  List<int> list = List<int>();
  list.addAll(intList((length / 2).round()));
  list.addAll(intList((length / 2).round()));
  list.shuffle();
  return list;
}