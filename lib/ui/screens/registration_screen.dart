import 'package:conciergego/bloc/auth_bloc.dart';
import 'package:conciergego/bloc/events/auth_event.dart';
import 'package:conciergego/bloc/states/auth_state.dart';
import 'package:conciergego/main.dart';
import 'package:conciergego/ui/screens/login_screen.dart';
import 'package:conciergego/ui/widgets/textfield_decorated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Registration page
class RegistrationScreen extends StatefulWidget {
  static const routeName = '/registration';

  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  /// Full name
  final _fullNameController = TextEditingController();

  /// E-mail input controller
  final TextEditingController _emailController = TextEditingController();

  /// Password input controller
  final TextEditingController _passwordController = TextEditingController();

  /// Password repeat input controller
  final TextEditingController _passwordRepeatController =
      TextEditingController();

  int _clientType = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New user registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigatorKey.currentState!.pushReplacementNamed(
              LoginScreen.routeName,
            );
          },
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Registration successfully. Now you can login with your e-mail and password",
                ),
              ),
            );
            navigatorKey.currentState!.pushReplacementNamed(
              LoginScreen.routeName,
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Registration",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  if (state is AuthRegistrationErrorState)
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 20),
                  TextFieldDecorated(
                    labelText: "Full name",
                    hintText: "What is your full name?",
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 20),
                  TextFieldDecorated(
                    labelText: "E-mail",
                    hintText: "What is your email address?",
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  TextFieldDecorated(
                    labelText: "Password",
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  TextFieldDecorated(
                    labelText: "Repeat password",
                    controller: _passwordRepeatController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<int>(
                        value: 0,
                        groupValue: _clientType,
                        onChanged: (int? value) {
                          setState(() {
                            _clientType = value ?? 0;
                          });
                        },
                      ),
                      const Text("Customer"),
                      const SizedBox(width: 30),
                      Radio<int>(
                        value: 1,
                        groupValue: _clientType,
                        onChanged: (int? value) {
                          setState(() {
                            _clientType = value ?? 0;
                          });
                        },
                      ),
                      const Text("Concierge"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 170,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_passwordController.text !=
                            _passwordRepeatController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Registration error: passwords do not match!",
                              ),
                            ),
                          );
                        } else {
                          BlocProvider.of<AuthBloc>(context).add(
                            AuthRegisterUserEvent(
                              fullname: _fullNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              profileType: _clientType,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceTint.withAlpha(100),
                      ),
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
