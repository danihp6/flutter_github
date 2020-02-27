import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/game.dart';
import 'models/player.dart';
import 'models/turn.dart';

Future<void> newGame(Game game) async {
  Firestore.instance.collection('games').add(game.toJson());
}

Future<DocumentReference> newPlayer(Player player) async {
  return await Firestore.instance.collection('players').add(player.toJson());
}

Future<DocumentReference> newTurn(Turn turn,String gameId) async {
  return await Firestore.instance.collection('games/$gameId/turns').add(turn.toJson());
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

Stream<List<Turn>> getTurns(String gameId) {
  return Firestore.instance
      .collection('games/$gameId/turns')
      .orderBy('turn')
      .snapshots()
      .map(toTurnList);
}
Stream<Player> getPlayerByDocumentReference(DocumentReference docRef){
  return docRef.snapshots().map(toPlayer);
}

Future<void> joinPlayerToGame(String gameId, String playerId){
  Firestore.instance.collection('games').document(gameId).updateData(
    {
      'players': FieldValue.arrayUnion([playerId]),
      'state': IN_PROGRESS,
    });
}
