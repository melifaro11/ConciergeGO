import 'package:conciergego/models/request_model.dart';
import 'package:flutter/cupertino.dart';


@immutable
abstract class UserRequestListState {}

class UserRequestListInitialState extends UserRequestListState {}

class UserRequestListLoadedState extends UserRequestListState {
  final List<RequestModel> requests;

  UserRequestListLoadedState({required this.requests});
}

class UserRequestListErrorState extends UserRequestListState {
  final String message;

  UserRequestListErrorState(this.message);
}
