import 'package:conciergego/models/user_profile_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UserRequestEvent {}

class UserRequestCreatedEvent extends UserRequestEvent {
  final String request;

  final UserProfileModel userProfile;

  UserRequestCreatedEvent({required this.request, required this.userProfile});
}

class UserRequestCompletedEvent extends UserRequestEvent {
  final String request;

  final UserProfileModel userProfile;

  final String llmResponse;

  UserRequestCompletedEvent({
    required this.request,
    required this.userProfile,
    required this.llmResponse,
  });
}

class UserRequestCancelledEvent extends UserRequestEvent {}
