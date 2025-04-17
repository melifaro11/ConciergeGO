import 'package:conciergego/models/user_profile_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class UserProfileEvent {}

class LoadUserProfileEvent extends UserProfileEvent {}

class UserProfileStreamUpdateEvent extends UserProfileEvent {
  final UserProfileModel userProfile;

  UserProfileStreamUpdateEvent(this.userProfile);
}

class UserProfileSaveEvent extends UserProfileEvent {
  final UserProfileModel userProfile;

  UserProfileSaveEvent(this.userProfile);
}

class ThemeChangeEvent extends UserProfileEvent {
  final bool darkTheme;

  ThemeChangeEvent(this.darkTheme);
}
