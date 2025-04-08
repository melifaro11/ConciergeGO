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
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    final UserProfileState state =
        BlocProvider.of<UserProfileBloc>(context).state;

    if (state is UserProfileInitialState) {
      BlocProvider.of<UserProfileBloc>(context).add(LoadUserProfileEvent());
    } else if (state is UserProfileLoadedState) {
      if (state.userProfile.openaiKey.isNotEmpty) {
        OpenAIService().init(state.userProfile.openaiKey);
      } else {
        navigatorKey.currentState!.pushNamed(UserProfileScreen.routeName);
      }
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
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
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final opacity =
                          sin(_controller.value * 2 * pi) * 0.35 + 0.65;
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
        } else if (userProfileState is UserProfileLoadedState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("ConciergeGO"),
              actions: [
                Switch(
                  value: userProfileState.userProfile.darkTheme,
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
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
