import 'package:conciergego/bloc/events/user_profile_event.dart';
import 'package:conciergego/bloc/events/user_request_event.dart';
import 'package:conciergego/bloc/events/user_request_list_event.dart';
import 'package:conciergego/bloc/states/user_profile_state.dart';
import 'package:conciergego/bloc/states/user_request_list_state.dart';
import 'package:conciergego/bloc/states/user_request_state.dart';
import 'package:conciergego/bloc/user_profile_bloc.dart';
import 'package:conciergego/bloc/user_request_bloc.dart';
import 'package:conciergego/bloc/user_request_list_bloc.dart';
import 'package:conciergego/ui/dialogs/questions_dialog.dart';
import 'package:conciergego/ui/dialogs/request_confirm_dialog.dart';
import 'package:conciergego/ui/dialogs/user_request_dialog.dart';
import 'package:conciergego/ui/main_menu.dart';
import 'package:conciergego/ui/widgets/elevated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestPage extends StatefulWidget {
  final UserProfileLoadedState userProfileState;

  const RequestPage({super.key, required this.userProfileState});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  void dispose() {
    debugPrint("RequestPage.dispose()");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRequestBloc = BlocProvider.of<UserRequestBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ConciergeGO"),
        actions: [
          Switch(
            value: widget.userProfileState.userProfile.darkTheme,
            onChanged: (value) {
              BlocProvider.of<UserProfileBloc>(
                context,
              ).add(ThemeChangeEvent(value));
            },
          ),
        ],
      ),
      drawer: const MainMenu(),
      body: Column(
        children: [
          /// List of user requests
          BlocBuilder<UserRequestListBloc, UserRequestListState>(
            builder: (context, state) {
              if (state is UserRequestListErrorState) {
                return Center(
                  child: Text(
                    "Error loading request list",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                );
              } else if (state is UserRequestListInitialState) {
                BlocProvider.of<UserRequestListBloc>(
                  context,
                ).add(UserRequestListLoadEvent());

                return Container();
              }

              final requestState = (state as UserRequestListLoadedState);

              return SingleChildScrollView(
                child: Column(
                  children:
                      requestState.requests
                          .map(
                            (request) => Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 150,
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Text(request.request),
                            ),
                          )
                          .toList(),
                ),
              );
            },
          ),

          /// New request
          BlocConsumer<UserRequestBloc, UserRequestState>(
            listener: (context, requestState) async {
              if (requestState is UserRequestQuestionsState) {
                final result = await showQuestionsListDialog(
                  context,
                  requestState.questions,
                );

                if (result != null) {
                  userRequestBloc.add(
                    UserRequestQuestionDoneEvent(
                      request: requestState.request,
                      userProfile: widget.userProfileState.userProfile,
                      questions: requestState.questions,
                      answers: result,
                    ),
                  );
                }
              } else if (requestState is UserRequestConfirmState) {
                final result = await showRequestConfirmDialog(
                  context,
                  requestState.request,
                );
                if (result != null) {
                  debugPrint("Final result: $result");
                  userRequestBloc.add(
                    UserRequestConfirmDoneEvent(
                      userUid: widget.userProfileState.userProfile.id!,
                      request: result,
                    ),
                  );
                }
              }
            },
            builder: (context, requestState) {
              final userRequestBloc = BlocProvider.of<UserRequestBloc>(context);

              return Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (requestState is UserRequestCreatedState)
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 20),
                                Text("Process your request, please wait..."),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      if (requestState is UserRequestErrorState)
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                "OpenAI API error: ${requestState.message}",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ElevatedIconButton(
                        width: 200,
                        onPressed: () async {
                          final result = await showUserRequestDialog(context);
                          if (result != null) {
                            userRequestBloc.add(
                              UserRequestCreatedEvent(
                                request: result,
                                userProfile:
                                    widget.userProfileState.userProfile,
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.add),
                        child: Text("Create request"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
