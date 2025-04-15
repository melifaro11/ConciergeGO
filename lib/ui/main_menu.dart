import 'package:conciergego/bloc/auth_bloc.dart';
import 'package:conciergego/bloc/events/auth_event.dart';
import 'package:conciergego/bloc/events/user_profile_event.dart';
import 'package:conciergego/bloc/user_profile_bloc.dart';
import 'package:conciergego/bloc/states/user_profile_state.dart';
import 'package:conciergego/models/user_profile_model.dart';
import 'package:conciergego/ui/screens/edit_user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  UserProfileModel? _userProfile;

  @override
  Widget build(BuildContext context) {
    final UserProfileBloc userProfileBloc = context.watch<UserProfileBloc>();

    final UserProfileState userProfileState = userProfileBloc.state;

    if (userProfileState is UserProfileLoadedState) {
      _userProfile = userProfileState.userProfile;
    }

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            accountName: Text(
              _userProfile?.baseInfo.fullName != null
                  ? _userProfile!.baseInfo.fullName!
                  : "anonymous",
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
                  if (_userProfile != null) {
                    userProfileBloc.add(
                      UserProfileUpdateEvent(
                        _userProfile!.copyWith(avatar: imageData),
                      ),
                    );
                  }
                });
              },
              child: CircleAvatar(
                backgroundImage:
                    _userProfile?.avatar != null
                        ? Image.memory(_userProfile!.avatar!).image
                        : null,
                child:
                    _userProfile?.avatar != null
                        ? null
                        : const FlutterLogo(size: 42),
              ),
            ),
          ),
          if (userProfileState is UserProfileLoadedState)
            ListTile(
              title: const Text("My profile"),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.popAndPushNamed(
                  context,
                  UserProfileEditScreen.routeName,
                );
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
