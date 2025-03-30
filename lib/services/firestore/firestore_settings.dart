import 'package:conciergego/models/settings_model.dart';
import 'package:conciergego/services/firestore/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service to access settings in firestore
class SettingsFirestoreService extends FirestoreService {
  /// Create service
  static final SettingsFirestoreService _singleton =
      SettingsFirestoreService._internal();

  factory SettingsFirestoreService() {
    return _singleton;
  }

  SettingsFirestoreService._internal();

  /// Get assistant model stream
  Stream<SettingsModel> getSettingsStream() {
    final User user = getLoggedUser();

    try {
      return firestore
          .collection('users')
          .doc(user.uid)
          .collection('settings')
          .doc('settings')
          .snapshots()
          .map((snapshot) {
        if (snapshot.data() != null) {
          return SettingsModel.fromJson(snapshot.id, snapshot.data()!);
        } else {
          return SettingsModel(
              id: null,
              userName: null,
              avatar: null,
              openaiKey: "",
              darkTheme: true);
        }
      });
    } on Exception catch (e) {
      throw FirestoreServiceException(
          "Get settings stream exception: ${e.toString()}");
    }
  }

  /// Update assistant model
  Future<void> updateSettings(SettingsModel settings) {
    final User user = getLoggedUser();

    final settingsRef = firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('settings');

    if (settings.id == null) {
      return settingsRef.set(settings.toJson());
    } else {
      return settingsRef.update(settings.toJson());
    }
  }
}
