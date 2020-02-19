import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twins_test_login/models/user.dart';

Future<DocumentReference> newUser(User user) async {
  return await Firestore.instance.collection('users').add(user.toJson());
}

Stream<User> getUserById(String id) {
  return Firestore.instance
      .collection('games')
      .document(id)
      .snapshots()
      .map((u)=>User.fromFirestore(u));
}