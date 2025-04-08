import 'dart:math';

import 'package:conciergego/bloc/auth_bloc.dart';
import 'package:conciergego/bloc/events/settings_event.dart';
import 'package:conciergego/bloc/settings_bloc.dart';
import 'package:conciergego/bloc/states/auth_state.dart';
import 'package:conciergego/bloc/states/settings_state.dart';
import 'package:conciergego/main.dart';
import 'package:conciergego/services/openai_service.dart';
import 'package:conciergego/ui/main_menu.dart';
import 'package:conciergego/ui/screens/login_screen.dart';
import 'package:conciergego/ui/screens/settings_screen.dart';
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
    final settingsState = context.watch<SettingsBloc>().state;

    if (settingsState is SettingsInitialState) {
      BlocProvider.of<SettingsBloc>(context).add(LoadUserSettingsEvent());
    } else if (settingsState is SettingsLoadedState) {
      isDarkTheme = settingsState.settings.darkTheme;
      OpenAIService().init(settingsState.settings.openaiKey);
    }

    context.watch<AuthBloc>().stream.listen((event) {
      if (event is! AuthLoggedState) {
        navigatorKey.currentState!.pushReplacementNamed(LoginScreen.routeName);
      }
    });

    if (settingsState is SettingsInitialState) {
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
    } else if (settingsState is SettingsLoadedState &&
        settingsState.settings.openaiKey.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("ConciergeGO"),
          actions: [
            Switch(
              value: isDarkTheme,
              onChanged: (value) {
                BlocProvider.of<SettingsBloc>(
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
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                "ConciergeGO",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 20),
            ],
          ),
          actions: [
            Switch(
              value: isDarkTheme,
              onChanged: (value) {
                BlocProvider.of<SettingsBloc>(
                  context,
                ).add(ThemeChangeEvent(value));
              },
            ),
          ],
        ),
        drawer: const MainMenu(),
        body: Padding(
          padding: const EdgeInsets.all(35),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/api_key.png', width: 100),
                const SizedBox(height: 20),
                Text(
                  "There is no OpenAI API-Key provided.\n\n"
                  "Please specify the API-Key in the settings",
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SettingsScreen.routeName);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 10),
                        Text("Open settings"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
