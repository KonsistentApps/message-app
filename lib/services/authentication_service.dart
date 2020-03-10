import 'dart:async';

import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../locator.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  final StreamController<User> _connectedUserController =
      StreamController<User>.broadcast();

  User _currentUser = User();

  User get currentUser => _currentUser;

  Stream listenToConnectedUser() {
    _connectedUserController.add(currentUser);
    return _connectedUserController.stream;
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    await _populateCurrentUser(user);
    return user != null;
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
      listenToConnectedUser();
    } else {
      _currentUser = null;
      listenToConnectedUser();
    }
  }

  Future loginWithEmail(
      {@required String email, @required String password}) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future logout() async {
    await _firebaseAuth.signOut()
        .then((value) async {
      await _populateCurrentUser(null);
    })
        .catchError((onError) {
          return "Something went wrong";});
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    @required String role,
  }) async {
    try {
      var _authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      _currentUser = User(
          id: _authResult.user.uid,
          email: email,
          fullName: fullName,
          userRole: role,
          discussions: [
            {'test': 'test'}
          ]);

      await _firestoreService.createUser(_currentUser);
      await _populateCurrentUser(_authResult.user);

      return _authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }
}
