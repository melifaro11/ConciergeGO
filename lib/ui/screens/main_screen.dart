import 'package:conciergego/bloc/auth_bloc.dart';
import 'package:conciergego/bloc/events/user_profile_event.dart';
import 'package:conciergego/bloc/user_profile_bloc.dart';
import 'package:conciergego/bloc/states/auth_state.dart';
import 'package:conciergego/bloc/states/user_profile_state.dart';
import 'package:conciergego/ui/pages/loading_page.dart';
import 'package:conciergego/ui/pages/request_page.dart';
import 'package:conciergego/ui/screens/login_screen.dart';
import 'package:conciergego/ui/screens/edit_user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main screen
class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  void dispose() {
    debugPrint('MainScreen.dispose()');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is! AuthLoggedState) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        }
      },
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, userProfileState) {
          if (userProfileState is UserProfileInitialState) {
            BlocProvider.of<UserProfileBloc>(
              context,
            ).add(LoadUserProfileEvent());
            return LoadingPage();
          } else if (userProfileState is UserProfileLoadedState) {
            if (userProfileState.userProfile.baseInfo.fullName == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(
                  context,
                ).pushNamed(UserProfileEditScreen.routeName);
              });
              //const openAiKey = String.fromEnvironment('OPENAI_API_KEY');
              //debugPrint("OPENAI KEY: $openAiKey");
              //OpenAIService().init(userProfileState.userProfile.openaiKey);
              //debugPrint("OpenAI initialized");
            } else {

            }
            return RequestPage(userProfileState: userProfileState);
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
