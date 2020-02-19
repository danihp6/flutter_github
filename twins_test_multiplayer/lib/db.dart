import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/game.dart';
import 'models/player.dart';

Future<void> newGame(Game game) async {
  Firestore.instance.collection('games').add(game.toJson());
}

Future<DocumentReference> newPlayer(Player player) async {
  return await Firestore.instance.collection('players').add(player.toJson());
}

Stream<Player> getPlayerById(String id) {
  return Firestore.instance
      .collection('players')
      .document(id)
      .snapshots()
      .map(toPlayer);
}

Stream<List<Game>> getGamesOrderByDatetime() {
  return Firestore.instance
      .collection('games')
      .orderBy('datetime')
      .snapshots()
      .map(toGameList);
}

Stream<Game> getGameById(String id) {
  return Firestore.instance
      .collection('games')
      .document(id)
      .snapshots()
      .map(toGame);
}
Stream<Player> getPlayerByDocumentReference(DocumentReference docRef){
  return docRef.snapshots().map(toPlayer);
}

Future<void> joinPlayerToGame(String gameId, String playerId) {
    Firestore db =Firestore.instance;
   DocumentReference docGame = db.collection("games").document(gameId);

    Firestore.instance.runTransaction((transaction) async {
          await transaction
          .update(docGame, {
            'players': FieldValue.arrayUnion([playerId]),
          })
          .catchError((e) {})
          .whenComplete(() {});
          DocumentSnapshot snapshotGame = await docGame.get();
          int numPlayers = snapshotGame.data['players'].length;
          if(numPlayers==1)
          await transaction
          .update(docGame, {
            'state': IN_PROGRESS,
          })
          .catchError((e) {})
          .whenComplete(() {
            print('game in progress');
          });
    }).catchError((e) {
      return false;
    });
}
