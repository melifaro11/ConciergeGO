import 'package:conciergego/models/request_model.dart';
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

  /// Returns stream of an user requests
  Stream<List<RequestModel>> getUserRequestsStream() {
    final user = getLoggedUser();

    try {
      return firestore
          .collection("requests")
          .where('userUid', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => RequestModel.fromJson(doc.data()))
                .toList();
          });
    } on Exception catch (e) {
      throw FirestoreServiceException("Get request error: ${e.toString()}");
    }
  }

  /// Get assistant model stream
  Stream<UserProfileModel> getUserProfileStream() {
    final User user = getLoggedUser();

    try {
      return firestore.collection('users').doc(user.uid).snapshots().map((
        snapshot,
      ) {
        if (snapshot.data() != null) {
          return UserProfileModel.fromJson(snapshot.id, snapshot.data()!);
        } else {
          return UserProfileModel(
            id: null,
            avatar: null,
            darkTheme: true,
            profileType: 0,
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

  Future<void> createNewUserProfile(UserProfileModel userProfile) async {
    await firestore
        .collection('users')
        .doc(userProfile.id)
        .set(userProfile.toJson());
  }

  Future<void> publishRequest(RequestModel request) async {
    await firestore.collection('requests').doc().set(request.toJson());
  }

  /// Update assistant model
  Future<void> updateUserProfile(UserProfileModel userProfile) {
    final User user = getLoggedUser();

    final userProfileRef = firestore.collection('users').doc(user.uid);

    if (userProfile.id == null) {
      return userProfileRef.set(userProfile.toJson());
    } else {
      return userProfileRef.update(userProfile.toJson());
    }
  }
}
