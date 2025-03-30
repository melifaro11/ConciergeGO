import 'package:firebase_auth/firebase_auth.dart';

/// Firebase auth service
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final AuthService _singleton = AuthService._internal();

  factory AuthService() {
    return _singleton;
  }

  AuthService._internal();

  /// Returns current logged user
  User? getLoggedUser() {
    return _auth.currentUser;
  }

  /// Register a new user with email and password
  Future<UserCredential> registerWithEmailPassword(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  /// Sign in user with email and password
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
