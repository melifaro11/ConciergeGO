import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {}

class AuthEmailLoginEvent extends AuthEvent {
  final String email;

  final String password;

  AuthEmailLoginEvent(this.email, this.password);
}

class AuthRegisterUserEvent extends AuthEvent {
  final String fullname;

  final String email;

  final String password;

  final int profileType;

  AuthRegisterUserEvent({
    required this.fullname,
    required this.email,
    required this.password,
    required this.profileType,
  });
}

class AuthSignOutEvent extends AuthEvent {}
