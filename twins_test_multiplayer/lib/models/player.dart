import 'package:cloud_firestore/cloud_firestore.dart';


const int NOT_IN_GAME=0;
const int IN_GAME=1;

class Player {
  String id;
  String name;

  Player({this.name,this.id});

  factory Player.fromFirestore(DocumentSnapshot doc) {
    return Player(
      id:doc.documentID,
      name: doc.data['name'],
    );
  }

  Map<String, dynamic> toJson() => {'name': name};

  @override
  String toString() {
    return 'id:$id,name:$name';
  }
}

Player toPlayer(DocumentSnapshot document) {
  return Player.fromFirestore(document);
}

List<Player> toPlayerList(QuerySnapshot query) {
  return query.documents.map((doc) => Player.fromFirestore(doc)).toList();
}
