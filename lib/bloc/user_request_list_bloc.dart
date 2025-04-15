import 'dart:async';

import 'package:conciergego/bloc/events/user_request_list_event.dart';
import 'package:conciergego/bloc/states/user_request_list_state.dart';
import 'package:conciergego/models/request_model.dart';
import 'package:conciergego/services/firestore/firestore_service.dart';
import 'package:conciergego/services/firestore/firestore_user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserRequestListBloc
    extends Bloc<UserRequestListEvent, UserRequestListState> {
  final _fireStore = UserProfileFirestoreService();

  StreamSubscription<List<RequestModel>>? _requestsSubscription;

  UserRequestListBloc() : super(UserRequestListInitialState()) {
    on<LoadRequestListEvent>(_onLoadRequestListEvent);
    on<UserRequestListStreamUpdateEvent>(_onUserRequestListStreamUpdateEvent);
  }

  void _onUserRequestListStreamUpdateEvent(
    UserRequestListStreamUpdateEvent event,
    Emitter<UserRequestListState> emitter,
  ) async {
    emitter(UserRequestListLoadedState(requests: event.requests));
  }

  void _onLoadRequestListEvent(
    LoadRequestListEvent event,
    Emitter<UserRequestListState> emitter,
  ) async {
    try {
      _requestsSubscription?.cancel();
      _requestsSubscription = _fireStore.getUserRequestsStream().listen((
        requests,
      ) {
        add(UserRequestListStreamUpdateEvent(requests));
      });
    } on FirestoreServiceException catch (e) {
      emitter(
        UserRequestListErrorState('Failed to select project ${e.message}'),
      );
    }
  }
}
