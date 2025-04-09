import 'package:conciergego/bloc/events/user_request_event.dart';
import 'package:conciergego/bloc/states/user_request_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserRequestBloc extends Bloc<UserRequestEvent, UserRequestState> {
  UserRequestBloc() : super(UserRequestInitialState()) {
    on<UserRequestCreatedEvent>(_onUserRequestCreatedEvent);
  }
  void _onUserRequestCreatedEvent(
    UserRequestCreatedEvent event,
    Emitter<UserRequestState> emitter,
  ) async {
    try {
      emitter(UserRequestCreatedState(event.request));

      String profileStr = "";

      profileStr +=
          "Nationality: ${event.userProfile.baseInfo.nationality ?? "not specified"}\n";
      profileStr +=
          "Accommodation preference: ${event.userProfile.preferences.accommodationPreference ?? "not specified"}\n";
      profileStr +=
          "Destination transport preference: ${event.userProfile.preferences.destinationTransportPreference ?? "not specified"}\n";
      profileStr +=
          "Flight preference: ${event.userProfile.preferences.flightPreference ?? "not specified"}\n";
      profileStr +=
          "Frequent flyer memberships: ${event.userProfile.preferences.frequentFlyerMemberships ?? "not specified"}\n";
      profileStr +=
          "Hotel category preference: ${event.userProfile.preferences.hotelCategoryPreference ?? "not specified"}\n";
      profileStr +=
          "Hotel loyalty memberships: ${event.userProfile.preferences.hotelLoyaltyMemberships ?? "not specified"}\n";
      profileStr +=
          "Preferred airline and class: ${event.userProfile.preferences.preferredAirlineAndClass ?? "not specified"}\n";
      profileStr +=
          "Tour preference: ${event.userProfile.preferences.tourPreference ?? "not specified"}\n";
      profileStr +=
          "Travel companion: ${event.userProfile.preferences.travelCompanion ?? "not specified"}\n";
      profileStr +=
          "Traveler type: ${event.userProfile.preferences.travelerType ?? "not specified"}\n";
      profileStr +=
          "Travel frequency: ${event.userProfile.preferences.travelFrequency ?? "not specified"}\n";

      debugPrint("Profile data\n===============\n$profileStr");
    } catch (e) {
      emitter(UserRequestErrorState(e.toString()));
    }
  }
}
