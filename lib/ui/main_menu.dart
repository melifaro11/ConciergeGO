import 'package:conciergego/bloc/auth_bloc.dart';
import 'package:conciergego/bloc/events/auth_event.dart';
import 'package:conciergego/bloc/events/settings_event.dart';
import 'package:conciergego/bloc/settings_bloc.dart';
import 'package:conciergego/bloc/states/settings_state.dart';
import 'package:conciergego/models/settings_model.dart';
import 'package:conciergego/ui/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  SettingsModel? _settings;

  @override
  Widget build(BuildContext context) {
    final SettingsState settingsState = context.watch<SettingsBloc>().state;

    if (settingsState is SettingsInitialState) {
      BlocProvider.of<SettingsBloc>(context).add(LoadUserSettingsEvent());
    } else if (settingsState is SettingsLoadedState) {
      _settings = settingsState.settings;
    }

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            accountName: Text(
              _settings?.userName != null ? _settings!.userName! : "anonymous",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).secondaryHeaderColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: const Text(""),
            currentAccountPicture: GestureDetector(
              onTap: () async {
                XFile? pickedFile = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                pickedFile?.readAsBytes().then((imageData) {
                  if (_settings != null) {
                    context.read<SettingsBloc>().add(
                      SettingsUpdateEvent(
                        _settings!.copyWith(avatar: imageData),
                      ),
                    );
                  }
                });
              },
              child: CircleAvatar(
                backgroundImage:
                    _settings?.avatar != null
                        ? Image.memory(_settings!.avatar!).image
                        : null,
                child:
                    _settings?.avatar != null
                        ? null
                        : const FlutterLogo(size: 42),
              ),
            ),
          ),
          //const Divider(),
          if (settingsState is SettingsLoadedState)
            ListTile(
              title: const Text("Settings"),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.popAndPushNamed(context, SettingsScreen.routeName);
              },
            ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: () {
              BlocProvider.of<AuthBloc>(context).add(AuthSignOutEvent());
            },
          ),
        ],
      ),
    );
  }
}
