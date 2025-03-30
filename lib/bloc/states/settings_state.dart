import 'package:conciergego/models/settings_model.dart';
import 'package:flutter/cupertino.dart';


@immutable
abstract class SettingsState {}

class SettingsInitialState extends SettingsState {}

class SettingsLoadedState extends SettingsState {
  final SettingsModel settings;

  SettingsLoadedState({required this.settings});
}

class SettingsErrorState extends SettingsState {
  final String message;

  SettingsErrorState(this.message);
}
