import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


const String userNotLoggedException = "User is not logged";

/// Exception class for database service
class FirestoreServiceException implements Exception {
  String message;

  FirestoreServiceException(this.message);
}

/// Service to access database
class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  /// Returns logged user or throws the FirestoreServiceException, if user is not logged in
  User getLoggedUser() {
    final User? user = firebaseAuth.currentUser;

    if (user == null) {
      throw FirestoreServiceException("User is not logged in");
    } else {
      return user;
    }
  }
}
