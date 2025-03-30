import 'dart:async';

import 'package:conciergego/bloc/events/settings_event.dart';
import 'package:conciergego/bloc/states/settings_state.dart';
import 'package:conciergego/models/settings_model.dart';
import 'package:conciergego/services/firestore/firestore_service.dart';
import 'package:conciergego/services/firestore/firestore_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsFirestoreService _fireStore = SettingsFirestoreService();

  StreamSubscription<SettingsModel>? _settingsSubscription;

  SettingsBloc() : super(SettingsInitialState()) {
    on<LoadUserSettingsEvent>(_onLoadUserSettingsEvent);
    on<SettingsStreamUpdateEvent>(_onSettingsStreamUpdateEvent);
    on<SettingsUpdateEvent>(_onSettingsUpdateEvent);
    on<ThemeChangeEvent>(_onThemeChangeEvent);
  }

  void _onSettingsStreamUpdateEvent(
      SettingsStreamUpdateEvent event, Emitter<SettingsState> emitter) async {
    emitter(SettingsLoadedState(settings: event.settings));
  }

  void _onThemeChangeEvent(
      ThemeChangeEvent event, Emitter<SettingsState> emitter) {
    if (state is SettingsLoadedState) {
      _fireStore.updateSettings((state as SettingsLoadedState)
          .settings
          .copyWith(darkTheme: event.darkTheme));
    }
  }

  void _onLoadUserSettingsEvent(
      LoadUserSettingsEvent event, Emitter<SettingsState> emitter) async {
    try {
      _settingsSubscription?.cancel();
      _settingsSubscription = _fireStore.getSettingsStream().listen((settings) {
        add(SettingsStreamUpdateEvent(settings));
      });
    } on FirestoreServiceException catch (e) {
      emitter(SettingsErrorState('Failed to select project ${e.message}'));
    }
  }

  void _onSettingsUpdateEvent(
      SettingsUpdateEvent event, Emitter<SettingsState> emitter) async {
    try {
      _fireStore.updateSettings(event.settings);
    } on FirestoreServiceException catch (e) {
      emitter(SettingsErrorState('Update settings error: $e'));
    }
  }
}
