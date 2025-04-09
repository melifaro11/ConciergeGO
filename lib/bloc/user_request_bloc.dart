import 'package:conciergego/bloc/events/user_request_event.dart';
import 'package:conciergego/bloc/states/user_request_state.dart';
import 'package:conciergego/models/user_profile_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserRequestBloc extends Bloc<UserRequestEvent, UserRequestState> {
  UserRequestBloc() : super(UserRequestInitialState()) {
    on<UserRequestCreatedEvent>(_onUserRequestCreatedEvent);
    on<UserRequestCancelledEvent>(_onUserRequestCancelledEvent);
  }

  void _onUserRequestCancelledEvent(
    UserRequestCancelledEvent event,
    Emitter<UserRequestState> emitter,
  ) {
    emitter(UserRequestInitialState());
  }

  void _onUserRequestCreatedEvent(
    UserRequestCreatedEvent event,
    Emitter<UserRequestState> emitter,
  ) async {
    try {
      emitter(UserRequestCreatedState(event.request));

      String profileStr =
          "Nationality: ${event.userProfile.baseInfo.nationality ?? "not specified"}\n";

      profileStr += buildPreferences(event.userProfile.preferences);

      debugPrint("Profile data\n===============\n$profileStr");

      emitter(
        UserRequestCompletedState(
          request: event.request,
          llmResponse: "HIER IS LLM RESPONSE",
        ),
      );
    } catch (e) {
      emitter(UserRequestErrorState(e.toString()));
    }
  }

  String buildPreferences(UserPreferencesModel userPreferences) {
    String preferences = "";

    preferences +=
        "Accommodation preference: ${userPreferences.accommodationPreference ?? "not specified"}\n";
    preferences +=
        "Destination transport preference: ${userPreferences.destinationTransportPreference ?? "not specified"}\n";
    preferences +=
        "Flight preference: ${userPreferences.flightPreference ?? "not specified"}\n";
    preferences +=
        "Frequent flyer memberships: ${userPreferences.frequentFlyerMemberships ?? "not specified"}\n";
    preferences +=
        "Hotel category preference: ${userPreferences.hotelCategoryPreference ?? "not specified"}\n";
    preferences +=
        "Hotel loyalty memberships: ${userPreferences.hotelLoyaltyMemberships ?? "not specified"}\n";
    preferences +=
        "Preferred airline and class: ${userPreferences.preferredAirlineAndClass ?? "not specified"}\n";
    preferences +=
        "Tour preference: ${userPreferences.tourPreference ?? "not specified"}\n";
    preferences +=
        "Travel companion: ${userPreferences.travelCompanion ?? "not specified"}\n";
    preferences +=
        "Traveler type: ${userPreferences.travelerType ?? "not specified"}\n";
    preferences +=
        "Travel frequency: ${userPreferences.travelFrequency ?? "not specified"}\n";

    return preferences;
  }
}
