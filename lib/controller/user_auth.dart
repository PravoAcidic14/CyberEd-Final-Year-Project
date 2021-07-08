import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fyp_app_design/view/first_screen.dart';

class UserAuth {
  final FirebaseAuth _firebaseAuth;
  UserAuth(this._firebaseAuth);

  Future signOut() async {
    await _firebaseAuth.signOut();
    return FirstScreen();
  }

  Future checkUserState() async {
    Stream<User> user = _firebaseAuth.authStateChanges();
    return user;
  }

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future userRegister({
    BuildContext context,
    String email,
    String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      print('Registered User Successfully');
      return Navigator.pushNamed(context, '/complete-profile');
    } on FirebaseAuthException catch (e) {
      return CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: e.message,
      );
    }
  }

  Future userSignIn(
      {BuildContext context, String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print('Signed In Successfully');
      return Navigator.pushNamed(context, '/student-home');
    } on FirebaseAuthException catch (e) {
      print('SignIn Error ' + e.toString());
      return CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: e.message,
      );
    }
  }
}
