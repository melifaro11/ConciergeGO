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

  final int profileType;

  AuthRegisterUserEvent(this.email, this.password, this.profileType);
}

class AuthSignOutEvent extends AuthEvent {}
