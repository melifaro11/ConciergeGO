import 'package:flutter/material.dart';

@immutable
abstract class UserRequestState {}

class UserRequestInitialState extends UserRequestState {}

class UserRequestCreatedState extends UserRequestState {
  final String request;

  UserRequestCreatedState(this.request);
}

class UserRequestCompletedState extends UserRequestState {
  final String request;

  final String llmResponse;

  UserRequestCompletedState({required this.request, required this.llmResponse});
}

class UserRequestErrorState extends UserRequestState {
  final String message;

  UserRequestErrorState(this.message);
}
