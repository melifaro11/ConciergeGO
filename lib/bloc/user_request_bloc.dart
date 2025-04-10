import 'dart:convert';

import 'package:conciergego/bloc/events/user_request_event.dart';
import 'package:conciergego/bloc/states/user_request_state.dart';
import 'package:conciergego/models/chat_model.dart';
import 'package:conciergego/models/questions_model.dart';
import 'package:conciergego/models/user_profile_model.dart';
import 'package:conciergego/services/openai_service.dart';
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

      OpenAIService()
          .chatRequest(
            messages: [MessageModel(content: event.request, role: "user")],
            model: "gpt-4",
            temperature: 0.3,
            instructions:
                " Analyze the user's request and profile. Your goal is to come"
                " up with a list of questions that need to be clarified by"
                " the user so that the performer can complete the tasks of"
                " the request. Output the result in JSON format, creating"
                " an array of questions 'questions'. Answer only JSON,"
                " no additional text."
                " User profile:\n\n$profileStr\n\nUser request:",
          )
          .then((llmResponse) {
            try {
              final QuestionsModel questionsModel = QuestionsModel.fromJson(
                jsonDecode(llmResponse.content),
              );

              emitter(
                UserRequestQuestionsState(
                  request: event.request,
                  questions: questionsModel.questions,
                ),
              );
            } catch (e) {
              emitter(UserRequestErrorState("Error parsing GPT response"));
            }
          });
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
