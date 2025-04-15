import 'package:conciergego/bloc/events/auth_event.dart';
import 'package:conciergego/bloc/states/auth_state.dart';
import 'package:conciergego/models/user_profile_model.dart';
import 'package:conciergego/services/auth_service.dart';
import 'package:conciergego/services/firestore/firestore_user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(_getInitialState()) {
    on<AuthEmailLoginEvent>(_onAuthEmailLoginEvent);
    on<AuthRegisterUserEvent>(_onRegisterUserEvent);
    on<AuthSignOutEvent>(_onAuthSignOutEvent);
  }

  static AuthState _getInitialState() {
    final loggedUser = AuthService().getLoggedUser();

    return loggedUser != null
        ? AuthLoggedState(loggedUser)
        : AuthInitialState();
  }

  void _onAuthEmailLoginEvent(
    AuthEmailLoginEvent event,
    Emitter<AuthState> emitter,
  ) async {
    try {
      emitter(AuthLoggingState());

      var credential = await AuthService().signInWithEmailPassword(
        event.email,
        event.password,
      );

      emitter(AuthLoggedState(credential.user!));
    } on FirebaseAuthException catch (e) {
      emitter(AuthErrorState(e.message ?? "Authorization failed"));
    } catch (e) {
      emitter(AuthErrorState(e.toString()));
    }
  }

  void _onAuthSignOutEvent(
    AuthSignOutEvent event,
    Emitter<AuthState> emitter,
  ) async {
    try {
      await AuthService().signOut();
      emitter(AuthInitialState());
    } catch (e) {
      emitter(AuthErrorState(e.toString()));
    }
  }

  void _onRegisterUserEvent(
    AuthRegisterUserEvent event,
    Emitter<AuthState> emitter,
  ) async {
    try {
      final userCredentials = await AuthService().registerWithEmailPassword(
        event.email,
        event.password,
      );

      if (userCredentials.user != null) {
        UserProfileFirestoreService().createNewUserProfile(
          UserProfileModel(
            id: userCredentials.user!.uid,
            avatar: null,
            darkTheme: true,
            profileType: event.profileType,
            openaiKey: "",
            baseInfo: UserBaseInfoModel(fullName: event.fullname),
            preferences: UserPreferencesModel(),
          ),
        );
      }

      emitter(AuthRegistrationSuccess());
    } on FirebaseAuthException catch (e) {
      emitter(AuthRegistrationErrorState("Registration error: ${e.message}"));
    } catch (e) {
      emitter(
        AuthRegistrationErrorState("Registration error: ${e.toString()}"),
      );
    }
  }
}
