import 'package:flutter/material.dart';

@immutable
abstract class UserRequestState {}

class UserRequestInitialState extends UserRequestState {}

class UserRequestCreatedState extends UserRequestState {
  final String request;

  UserRequestCreatedState(this.request);
}

class UserRequestErrorState extends UserRequestState {
  final String message;

  UserRequestErrorState(this.message);
}
