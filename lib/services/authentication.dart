import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_examen/globals/globals.dart' as g;
import 'package:test_examen/model/user_info_details.dart';

abstract class BaseAuth {
  Future<String> signInWithGoogle();

  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<void> signOutGoogle();

  Future<void> disconnect();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /*Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }*/

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final FirebaseUser user =
    await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    //return 'signInWithGoogle succeeded: $user';
    print('signInWithGoogle succeeded: $user');

    g.userInfoDetails =  new UserInfoDetails(
        user.providerId, user.displayName != null ? user.displayName : user.email, user.email, user.photoUrl != null ? user.photoUrl : g.URL_LOGO_POR_DEFECTO, user.uid);

    return user.uid;
  }

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    g.userInfoDetails =  new UserInfoDetails(
        user.providerId, user.displayName != null ? user.displayName : user.email, user.email, user.photoUrl != null ? user.photoUrl : g.URL_LOGO_POR_DEFECTO, user.uid);

    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> signOutGoogle() async {
    return _googleSignIn.signOut();
  }

  Future<void> disconnect() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    return _googleSignIn.disconnect();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

}