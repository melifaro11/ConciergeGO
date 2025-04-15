import 'package:conciergego/models/user_profile_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UserRequestEvent {}

class UserRequestCreatedEvent extends UserRequestEvent {
  final String request;

  final UserProfileModel userProfile;

  UserRequestCreatedEvent({required this.request, required this.userProfile});
}

class UserRequestQuestionDoneEvent extends UserRequestEvent {
  final String request;

  final UserProfileModel userProfile;

  final List<String> questions;

  final List<String> answers;

  UserRequestQuestionDoneEvent({
    required this.request,
    required this.userProfile,
    required this.questions,
    required this.answers,
  });
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

class UserRequestConfirmDoneEvent extends UserRequestEvent {
  final String userUid;

  final String request;

  UserRequestConfirmDoneEvent({required this.userUid, required this.request});
}

class UserRequestCancelledEvent extends UserRequestEvent {}
