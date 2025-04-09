import 'package:conciergego/bloc/events/user_profile_event.dart';
import 'package:conciergego/bloc/events/user_request_event.dart';
import 'package:conciergego/bloc/states/user_profile_state.dart';
import 'package:conciergego/bloc/states/user_request_state.dart';
import 'package:conciergego/bloc/user_profile_bloc.dart';
import 'package:conciergego/bloc/user_request_bloc.dart';
import 'package:conciergego/ui/dialogs/user_request_dialog.dart';
import 'package:conciergego/ui/main_menu.dart';
import 'package:conciergego/ui/widgets/elevated_icon_button.dart';
import 'package:conciergego/ui/widgets/textfield_decorated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestPage extends StatefulWidget {
  final UserProfileLoadedState userProfileState;

  const RequestPage({super.key, required this.userProfileState});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _llmResponseController = TextEditingController();

  final _userRequestController = TextEditingController();

  @override
  void dispose() {
    debugPrint("RequestPage.dispose()");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<UserRequestBloc, UserRequestState>(
        builder: (context, requestState) {
          final userRequestBloc = BlocProvider.of<UserRequestBloc>(context);

          if (requestState is UserRequestCreatedState) {
            return Padding(
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
            );
          } else if (requestState is UserRequestCompletedState) {
            _llmResponseController.text = requestState.llmResponse;
            _userRequestController.text = requestState.request;

            return Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: TextFieldDecorated(
                        controller: _llmResponseController,
                        maxLines: 40,
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedIconButton(
                          onPressed: () {
                            BlocProvider.of<UserRequestBloc>(context).add(
                              UserRequestCancelledEvent()
                            );
                          },
                          width: 200,
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withValues(red: 150, alpha: 0.4),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 25),
                        ElevatedIconButton(
                          onPressed: () {},
                          width: 250,
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withValues(green: 150, alpha: 0.4),
                          child: Text(
                            "PUBLISH",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60),
                    TextFieldDecorated(
                      controller: _userRequestController,
                      maxLines: 3,
                      width: MediaQuery.of(context).size.width * 0.9,
                      hintText: "Correct request...",
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedIconButton(
                    width: 200,
                    onPressed: () async {
                      final result = await showUserRequestDialog(context);
                      if (result != null) {
                        userRequestBloc.add(
                          UserRequestCreatedEvent(
                            request: result,
                            userProfile: widget.userProfileState.userProfile,
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
    );
  }
}
