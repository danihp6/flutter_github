import 'package:cloud_firestore/cloud_firestore.dart';

const int ENDED = 0;
const int HAPPENING = 1;

class Turn {
  String id;
  int turn;
  int state;
  DateTime timer;
  int turnOfPlayer;

  Turn({this.id, this.state,this.timer,this.turn,this.turnOfPlayer});

  factory Turn.fromFirestore(DocumentSnapshot doc) {
    return Turn(
        id: doc.documentID,
        state: doc.data['state'],
        timer: (doc.data['timer'] as Timestamp).toDate(),
        turn: doc.data['turn'],
        turnOfPlayer:doc.data['turnOfPlayer']
        );
  }

Map<String, dynamic> toJson() =>{
        'state': state,
        'timer':timer,
        'turn':turn,
        'turnOfPlayer':turnOfPlayer
  };

  @override
  String toString() {
    return 'id:$id,state:$state,timer:$timer,turn:$turn,turnOfPlayer:$turnOfPlayer';
  }
}

List<Turn> toTurnList(QuerySnapshot query) {
  return query.documents.map((doc) => Turn.fromFirestore(doc)).toList();
}

Turn toTurn(DocumentSnapshot document) {
  return Turn.fromFirestore(document);
}