import 'package:conciergego/models/user_profile_model.dart';
import 'package:flutter/cupertino.dart';


@immutable
abstract class UserProfileState {}

class UserProfileInitialState extends UserProfileState {}

class UserProfileLoadedState extends UserProfileState {
  final UserProfileModel userProfile;

  UserProfileLoadedState({required this.userProfile});
}

class UserProfileErrorState extends UserProfileState {
  final String message;

  UserProfileErrorState(this.message);
}
