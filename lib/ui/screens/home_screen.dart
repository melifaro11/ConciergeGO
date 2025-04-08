import 'dart:math';

import 'package:conciergego/bloc/auth_bloc.dart';
import 'package:conciergego/bloc/events/user_profile_event.dart';
import 'package:conciergego/bloc/user_profile_bloc.dart';
import 'package:conciergego/bloc/states/auth_state.dart';
import 'package:conciergego/bloc/states/user_profile_state.dart';
import 'package:conciergego/main.dart';
import 'package:conciergego/services/openai_service.dart';
import 'package:conciergego/ui/main_menu.dart';
import 'package:conciergego/ui/screens/login_screen.dart';
import 'package:conciergego/ui/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main screen
class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var isDarkTheme = true;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    //var isDarkTheme = true;
    final settingsState = context.watch<UserProfileBloc>().state;

    if (settingsState is UserProfileInitialState) {
      BlocProvider.of<UserProfileBloc>(context).add(LoadUserProfileEvent());
    } else if (settingsState is UserProfileLoadedState) {
      isDarkTheme = settingsState.userProfile.darkTheme;
      OpenAIService().init(settingsState.userProfile.openaiKey);
    }

    context.watch<AuthBloc>().stream.listen((event) {
      if (event is! AuthLoggedState) {
        navigatorKey.currentState!.pushReplacementNamed(LoginScreen.routeName);
      }
    });

    if (settingsState is UserProfileInitialState) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final opacity = sin(_controller.value * 2 * pi) * 0.35 + 0.65;
                  return Opacity(
                    opacity: opacity.clamp(0.2, 0.8),
                    child: Text(
                      "Connect to the server...",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),
              const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      );
    } else if (settingsState is UserProfileLoadedState &&
        settingsState.userProfile.openaiKey.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("ConciergeGO"),
          actions: [
            Switch(
              value: isDarkTheme,
              onChanged: (value) {
                BlocProvider.of<UserProfileBloc>(
                  context,
                ).add(ThemeChangeEvent(value));
              },
            ),
          ],
        ),
        drawer: const MainMenu(),
        body: Center(child: Text("EMPTY")),
      );
    } else {
      return UserProfileScreen();
    }
  }
}
