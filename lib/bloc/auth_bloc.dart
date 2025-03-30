import 'package:conciergego/bloc/events/auth_event.dart';
import 'package:conciergego/bloc/states/auth_state.dart';
import 'package:conciergego/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();

  AuthBloc() : super(AuthInitialState()) {
    on<AuthEmailLoginEvent>(_onAuthEmailLoginEvent);
    on<AuthRegisterUserEvent>(_onRegisterUserEvent);
    on<AuthSignOutEvent>(_onAuthSignOutEvent);

    if (_authService.getLoggedUser() != null) {
      emit(AuthLoggedState(_authService.getLoggedUser()!));
    }
  }

  void _onAuthEmailLoginEvent(
      AuthEmailLoginEvent event, Emitter<AuthState> emitter) async {
    try {
      emitter(AuthLoggingState());

      var credential = await _authService.signInWithEmailPassword(
          event.email, event.password);

      emitter(AuthLoggedState(credential.user!));
    } on FirebaseAuthException catch (e) {
      emitter(AuthErrorState(e.message ?? "Authorization failed"));
    } catch (e) {
      emitter(AuthErrorState(e.toString()));
    }
  }

  void _onAuthSignOutEvent(
      AuthSignOutEvent event, Emitter<AuthState> emitter) async {
    try {
      await _authService.signOut();
      emitter(AuthInitialState());
    } catch (e) {
      emitter(AuthErrorState(e.toString()));
    }
  }

  /// Register new user
  void _onRegisterUserEvent(AuthRegisterUserEvent event, Emitter<AuthState> emitter) async {
    try {
      await _authService.registerWithEmailPassword(
          event.email, event.password);
      emitter(AuthRegistrationSuccess());
    } on FirebaseAuthException catch (e) {
      emitter(AuthRegistrationErrorState("Registration error: ${e.message}"));
    } catch (e) {
      emitter(AuthRegistrationErrorState("Registration error: ${e.toString()}"));
    }
  }
}
