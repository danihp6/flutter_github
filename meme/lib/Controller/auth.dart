import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meme/Models/User.dart';
import 'db.dart';

enum AuthStatus {
  notSignedIn,
  signedIn,
}

abstract class BaseAuth {
  AuthStatus _authStatus;
  Future initAuth();
  Future<String> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> registerUser(User user, String password);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  Future<AuthStatus> initAuth() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null) {
      this._authStatus = AuthStatus.signedIn;
      db.userId = await db.getUserByEmail(user.email);
    } else
      this._authStatus = AuthStatus.notSignedIn;
    return this._authStatus;
  }

  get authStatus => this._authStatus;

  set authStatus(authStatus) => this._authStatus = authStatus;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    _authStatus = AuthStatus.signedIn;
    return user.uid;
  }

  Future<String> registerUser(User user, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email, password: password);
    FirebaseUser firebaseUser = result.user;
    db.newUser(user);
    _authStatus = AuthStatus.signedIn;
    return firebaseUser.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    _authStatus = AuthStatus.notSignedIn;
    return _firebaseAuth.signOut();
  }

  Future<FirebaseUser> reauthCurrentUser(String password) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    AuthCredential credential = EmailAuthProvider.getCredential(
      email: user.email,
      password: password
    );

    return (await user.reauthenticateWithCredential(credential)).user;

  }

  Future deleteUser(String password) async {
    FirebaseUser user = await reauthCurrentUser(password);
    user.delete();
  }
}

Auth auth = new Auth();
