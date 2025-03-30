import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoggingState extends AuthState {}

class AuthLoggedState extends AuthState {
  final User user;

  AuthLoggedState(this.user);
}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState(this.message);
}

class AuthRegistrationSuccess extends AuthState {}

class AuthRegistrationErrorState extends AuthState {
  final String message;

  AuthRegistrationErrorState(this.message);
}
