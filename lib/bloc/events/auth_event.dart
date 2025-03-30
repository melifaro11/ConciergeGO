import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {}

class AuthEmailLoginEvent extends AuthEvent {
  final String email;

  final String password;

  AuthEmailLoginEvent(this.email, this.password);
}

class AuthRegisterUserEvent extends AuthEvent {
  final String email;

  final String password;

  AuthRegisterUserEvent(this.email, this.password);
}

class AuthSignOutEvent extends AuthEvent {}
