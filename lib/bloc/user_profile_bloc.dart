import 'dart:async';

import 'package:conciergego/bloc/events/user_profile_event.dart';
import 'package:conciergego/bloc/states/user_profile_state.dart';
import 'package:conciergego/models/user_profile_model.dart';
import 'package:conciergego/services/firestore/firestore_service.dart';
import 'package:conciergego/services/firestore/firestore_user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileFirestoreService _fireStore = UserProfileFirestoreService();

  StreamSubscription<UserProfileModel>? _userProfileSubscription;

  UserProfileBloc() : super(UserProfileInitialState()) {
    on<LoadUserProfileEvent>(_onLoadUserProfileEvent);
    on<UserProfileStreamUpdateEvent>(_onUserProfileStreamUpdateEvent);
    on<UserProfileSaveEvent>(_onUserProfileSaveEvent);
    on<ThemeChangeEvent>(_onThemeChangeEvent);
  }

  void _onUserProfileStreamUpdateEvent(
    UserProfileStreamUpdateEvent event,
    Emitter<UserProfileState> emitter,
  ) async {
    emitter(UserProfileLoadedState(userProfile: event.userProfile));
  }

  void _onThemeChangeEvent(
    ThemeChangeEvent event,
    Emitter<UserProfileState> emitter,
  ) {
    if (state is UserProfileLoadedState) {
      _fireStore.updateUserProfile(
        (state as UserProfileLoadedState).userProfile.copyWith(
          darkTheme: event.darkTheme,
        ),
      );
    }
  }

  void _onLoadUserProfileEvent(
    LoadUserProfileEvent event,
    Emitter<UserProfileState> emitter,
  ) async {
    try {
      _userProfileSubscription?.cancel();
      _userProfileSubscription = _fireStore.getUserProfileStream().listen((
        userProfile,
      ) {
        add(UserProfileStreamUpdateEvent(userProfile));
      });
    } on FirestoreServiceException catch (e) {
      emitter(UserProfileErrorState('Failed to select project ${e.message}'));
    }
  }

  void _onUserProfileSaveEvent(
    UserProfileSaveEvent event,
    Emitter<UserProfileState> emitter,
  ) async {
    try {
      _fireStore.updateUserProfile(event.userProfile);
    } on FirestoreServiceException catch (e) {
      emitter(UserProfileErrorState('Update settings error: $e'));
    }
  }
}
