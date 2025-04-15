import 'package:conciergego/models/request_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class UserRequestListEvent {}

class LoadRequestListEvent extends UserRequestListEvent {}

class UserRequestListStreamUpdateEvent extends UserRequestListEvent {
  final List<RequestModel> requests;

  UserRequestListStreamUpdateEvent(this.requests);
}
