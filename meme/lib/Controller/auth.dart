import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meme/Models/User.dart';
import 'db.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<FirebaseUser> get getAuthStatus => _firebaseAuth.onAuthStateChanged;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> registerUser(User user, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email, password: password);
    FirebaseUser firebaseUser = result.user;
    db.newUser(user);
    signIn(user.email, password);
    return firebaseUser.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<FirebaseUser> reauthCurrentUser(String password) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    AuthCredential credential =
        EmailAuthProvider.getCredential(email: user.email, password: password);

    return (await user.reauthenticateWithCredential(credential)).user;
  }

  Future deleteUser(String password) async {
    FirebaseUser user = await reauthCurrentUser(password);
    
    db.deleteUser(db.userId);
    user.delete();
  }
}

Auth auth = new Auth();
