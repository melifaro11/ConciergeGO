import 'package:conciergego/bloc/auth_bloc.dart';
import 'package:conciergego/bloc/events/user_profile_event.dart';
import 'package:conciergego/bloc/user_profile_bloc.dart';
import 'package:conciergego/bloc/states/auth_state.dart';
import 'package:conciergego/bloc/states/user_profile_state.dart';
import 'package:conciergego/main.dart';
import 'package:conciergego/services/openai_service.dart';
import 'package:conciergego/ui/pages/loading_page.dart';
import 'package:conciergego/ui/pages/request_page.dart';
import 'package:conciergego/ui/screens/login_screen.dart';
import 'package:conciergego/ui/screens/user_profile_edit_screen.dart';
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('MainScreen.dispose()');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthBloc>().stream.listen((event) {
      if (event is! AuthLoggedState) {
        navigatorKey.currentState!.pushReplacementNamed(LoginScreen.routeName);
      }
    });

    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, userProfileState) {
        if (userProfileState is UserProfileInitialState) {
          BlocProvider.of<UserProfileBloc>(context).add(LoadUserProfileEvent());
          return LoadingPage();
        } else if (userProfileState is UserProfileLoadedState) {
          if (userProfileState.userProfile.openaiKey.isNotEmpty) {
            OpenAIService().init(userProfileState.userProfile.openaiKey);
            debugPrint("OpenAI initialized");
          } else {
            navigatorKey.currentState!.pushNamed(
              UserProfileEditScreen.routeName,
            );
          }
          return RequestPage(userProfileState: userProfileState);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
