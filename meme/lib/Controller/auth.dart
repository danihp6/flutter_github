import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meme/Controller/push_notification_provider.dart';
import 'package:meme/Models/User.dart';
import 'db.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  Future<String> currentUserEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
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

  Future deleteUser(FirebaseUser user) async {
    db.deleteUser(db.userId);
    user.delete();
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult result =
        await _firebaseAuth.signInWithCredential(credential);
    FirebaseUser user = result.user;
    return user;
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future changePassword(FirebaseUser user, String newPassword) async {
    user.updatePassword(newPassword);
  }

  Future changeEmail(FirebaseUser user, String newEmail) async {
    user.updateEmail(newEmail);
  }
}

Auth auth = new Auth();
