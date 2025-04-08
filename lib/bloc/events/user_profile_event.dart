import 'package:conciergego/models/user_profile_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class UserProfileEvent {}

class LoadUserProfileEvent extends UserProfileEvent {}

class UserProfileStreamUpdateEvent extends UserProfileEvent {
  final UserProfileModel settings;

  UserProfileStreamUpdateEvent(this.settings);
}

class UserProfileUpdateEvent extends UserProfileEvent {
  final UserProfileModel settings;

  UserProfileUpdateEvent(this.settings);
}

class ThemeChangeEvent extends UserProfileEvent {
  final bool darkTheme;

  ThemeChangeEvent(this.darkTheme);
}
