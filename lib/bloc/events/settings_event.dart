import 'package:conciergego/models/settings_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SettingsEvent {}

class LoadUserSettingsEvent extends SettingsEvent {}

class SettingsStreamUpdateEvent extends SettingsEvent {
  final SettingsModel settings;

  SettingsStreamUpdateEvent(this.settings);
}

class SettingsUpdateEvent extends SettingsEvent {
  final SettingsModel settings;

  SettingsUpdateEvent(this.settings);
}

class ThemeChangeEvent extends SettingsEvent {
  final bool darkTheme;

  ThemeChangeEvent(this.darkTheme);
}
