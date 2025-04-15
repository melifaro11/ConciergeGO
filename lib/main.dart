import 'dart:ui';

import 'package:conciergego/bloc/auth_bloc.dart';
import 'package:conciergego/bloc/user_profile_bloc.dart';
import 'package:conciergego/bloc/states/user_profile_state.dart';
import 'package:conciergego/bloc/user_request_bloc.dart';
import 'package:conciergego/bloc/user_request_list_bloc.dart';
import 'package:conciergego/firebase_options.dart';
import 'package:conciergego/ui/screens/main_screen.dart';
import 'package:conciergego/ui/screens/login_screen.dart';
import 'package:conciergego/ui/screens/registration_screen.dart';
import 'package:conciergego/ui/screens/user_profile_edit_screen.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final lightTheme = ThemeData.light(useMaterial3: true);

final darkTheme = ThemeData.dark(useMaterial3: true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OpenAI.showLogs = true;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<UserProfileBloc>(create: (context) => UserProfileBloc()),
        BlocProvider<UserRequestBloc>(create: (context) => UserRequestBloc()),
        BlocProvider<UserRequestListBloc>(
          create: (context) => UserRequestListBloc(),
        ),
      ],
      child: const ConciergeGoApp(),
    ),
  );
}

class ConciergeGoApp extends StatelessWidget {
  const ConciergeGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    var isDarkTheme = true;

    final settingsState = context.watch<UserProfileBloc>().state;

    if (settingsState is UserProfileLoadedState) {
      isDarkTheme = settingsState.userProfile.darkTheme;
    }

    return MaterialApp(
      title: 'ConciergeGO',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      navigatorKey: navigatorKey,
      initialRoute: LoginScreen.routeName,
      scrollBehavior: CustomScrollBehavior(),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegistrationScreen.routeName: (context) => const RegistrationScreen(),
        MainScreen.routeName: (context) => const MainScreen(),
        UserProfileEditScreen.routeName:
            (context) => const UserProfileEditScreen(),
      },
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}
