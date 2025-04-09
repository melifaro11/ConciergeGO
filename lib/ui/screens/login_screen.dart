import 'package:conciergego/bloc/auth_bloc.dart';
import 'package:conciergego/bloc/events/auth_event.dart';
import 'package:conciergego/bloc/events/user_profile_event.dart';
import 'package:conciergego/bloc/user_profile_bloc.dart';
import 'package:conciergego/bloc/states/auth_state.dart';
import 'package:conciergego/main.dart';
import 'package:conciergego/ui/screens/main_screen.dart';
import 'package:conciergego/ui/screens/registration_screen.dart';
import 'package:conciergego/ui/widgets/textfield_decorated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Login screen
class LoginScreen extends StatefulWidget {
  static const routeName = '/';

  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  /// E-mail input controller
  final TextEditingController _emailController = TextEditingController();

  /// Password input controller
  final TextEditingController _passwordController = TextEditingController();

  /// Submit login form
  void _submitLoginForm() {
    BlocProvider.of<AuthBloc>(
      context,
    ).add(AuthEmailLoginEvent(_emailController.text, _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedState) {
          BlocProvider.of<UserProfileBloc>(context).add(LoadUserProfileEvent());
          navigatorKey.currentState!.pushReplacementNamed(MainScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: null),
          body: Center(
            child: SizedBox(
              width: 370,
              height: state is AuthErrorState ? 420 : 470,
              child: Stack(
                children: [
                  if (state is AuthLoggingState)
                    const Center(child: CircularProgressIndicator()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/login_icon.png",
                            width: 130,
                            opacity: const AlwaysStoppedAnimation(0.7),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "ConciergeGO",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      if (state is AuthErrorState)
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      TextFieldDecorated(
                        labelText: "E-mail",
                        controller: _emailController,
                        onSubmitted: (text) {
                          _submitLoginForm();
                        },
                      ),
                      TextFieldDecorated(
                        labelText: "Password",
                        obscureText: true,
                        controller: _passwordController,
                        onSubmitted: (text) {
                          _submitLoginForm();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 130,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: _submitLoginForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surfaceTint.withAlpha(100),
                              ),
                              child: const Text('Login'),
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                navigatorKey.currentState!.pushReplacementNamed(
                                  RegistrationScreen.routeName,
                                );
                              },
                              child: const Text('Register'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
