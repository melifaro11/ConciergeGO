import 'package:flutter/material.dart';

@immutable
abstract class UserRequestState {}

class UserRequestInitialState extends UserRequestState {}

class UserRequestCreatedState extends UserRequestState {
  final String request;

  UserRequestCreatedState(this.request);
}

class UserRequestQuestionsState extends UserRequestState {
  final String request;

  final List<String> questions;

  UserRequestQuestionsState({required this.request, required this.questions});
}

class UserRequestConfirmState extends UserRequestState {
  final String request;

  UserRequestConfirmState({required this.request});
}

class UserRequestErrorState extends UserRequestState {
  final String message;

  UserRequestErrorState(this.message);
}
