import 'package:conciergego/models/user_profile_model.dart';
import 'package:conciergego/services/firestore/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service to access settings in firestore
class UserProfileFirestoreService extends FirestoreService {
  /// Create service
  static final UserProfileFirestoreService _singleton =
      UserProfileFirestoreService._internal();

  factory UserProfileFirestoreService() {
    return _singleton;
  }

  UserProfileFirestoreService._internal();

  /// Get assistant model stream
  Stream<UserProfileModel> getUserProfileStream() {
    final User user = getLoggedUser();

    try {
      return firestore
          .collection('users')
          .doc(user.uid)
          .collection('profile')
          .doc('profile')
          .snapshots()
          .map((snapshot) {
            if (snapshot.data() != null) {
              return UserProfileModel.fromJson(snapshot.id, snapshot.data()!);
            } else {
              return UserProfileModel(
                id: null,
                //userName: null,
                avatar: null,
                openaiKey: "",
                darkTheme: true,
                baseInfo: UserBaseInfoModel(),
                preferences: UserPreferencesModel(),
              );
            }
          });
    } on Exception catch (e) {
      throw FirestoreServiceException(
        "Get settings stream exception: ${e.toString()}",
      );
    }
  }

  /// Update assistant model
  Future<void> updateUserProfile(UserProfileModel userProfile) {
    final User user = getLoggedUser();

    final userProfileRef = firestore
        .collection('users')
        .doc(user.uid)
        .collection('profile')
        .doc('profile');

    if (userProfile.id == null) {
      return userProfileRef.set(userProfile.toJson());
    } else {
      return userProfileRef.update(userProfile.toJson());
    }
  }
}
