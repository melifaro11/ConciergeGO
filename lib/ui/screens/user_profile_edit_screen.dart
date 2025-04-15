import 'dart:typed_data';

import 'package:conciergego/bloc/auth_bloc.dart';
import 'package:conciergego/bloc/events/user_profile_event.dart';
import 'package:conciergego/bloc/states/auth_state.dart';
import 'package:conciergego/bloc/user_profile_bloc.dart';
import 'package:conciergego/bloc/states/user_profile_state.dart';
import 'package:conciergego/main.dart';
import 'package:conciergego/models/user_profile_model.dart';
import 'package:conciergego/ui/screens/login_screen.dart';
import 'package:conciergego/ui/widgets/textfield_decorated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileEditScreen extends StatefulWidget {
  static const routeName = '/user_profile_edit';

  const UserProfileEditScreen({super.key});

  @override
  State<UserProfileEditScreen> createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
  //UserProfileModel? _userProfile;

  Uint8List? _avatar;

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _nickNameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _communicationMethodController =
      TextEditingController();

  final TextEditingController _nationalityController = TextEditingController();

  final TextEditingController _openaiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // final UserProfileState state =
    //     BlocProvider.of<UserProfileBloc>(context).state;
    //
    // if (state is UserProfileLoadedState) {
    //   _userProfile = state.userProfile;
    //   _avatar = _userProfile?.avatar;
    //   _nameController.text = _userProfile?.baseInfo.fullName ?? "";
    //   _openaiKeyController.text = _userProfile?.openaiKey ?? "";
    //
    //   _nickNameController.text = _userProfile?.baseInfo.nickName ?? "";
    //   _phoneNumberController.text = _userProfile?.baseInfo.phoneNumber ?? "";
    //   _communicationMethodController.text =
    //       _userProfile?.baseInfo.communicationMethod ?? "";
    //   _nationalityController.text = _userProfile?.baseInfo.nationality ?? "";
    // } else if (state is UserProfileInitialState) {
    //   BlocProvider.of<UserProfileBloc>(context).add(LoadUserProfileEvent());
    //   debugPrint("Loading..");
    // }
    // debugPrint('AAAAFFFFFFFFFFFFFFFF');
    // debugPrint(_userProfile.toString());
  }

  @override
  Widget build(BuildContext context) {
    final UserProfileBloc userProfileBloc = BlocProvider.of<UserProfileBloc>(
      context,
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is! AuthLoggedState) {
          Navigator.popAndPushNamed(context, LoginScreen.routeName);
        }
      },
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, profileState) {
          if (profileState is UserProfileInitialState) {
            BlocProvider.of<UserProfileBloc>(
              context,
            ).add(LoadUserProfileEvent());
            return Center(child: CircularProgressIndicator());
          }

          final userProfile =
              (profileState as UserProfileLoadedState).userProfile;

          _avatar = userProfile.avatar;
          _nameController.text = userProfile.baseInfo.fullName ?? "";
          _openaiKeyController.text = userProfile.openaiKey ?? "";

          _nickNameController.text = userProfile.baseInfo.nickName ?? "";
          _phoneNumberController.text = userProfile.baseInfo.phoneNumber ?? "";
          _communicationMethodController.text =
              userProfile.baseInfo.communicationMethod ?? "";
          _nationalityController.text = userProfile.baseInfo.nationality ?? "";

          return Scaffold(
            appBar: AppBar(
              title: const Text("My Profile"),
              automaticallyImplyLeading:
                  userProfile.openaiKey.isNotEmpty ? true : false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: 58,
                      backgroundColor: Theme.of(context).primaryColorLight,
                      backgroundImage:
                          _avatar != null ? Image.memory(_avatar!).image : null,
                      child: GestureDetector(
                        child: Icon(
                          CupertinoIcons.camera,
                          color: Theme.of(context).shadowColor,
                        ),
                        onTap: () async {
                          XFile? pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );

                          pickedFile?.readAsBytes().then((imageData) {
                            final newUserProfile = userProfile.copyWith(
                              avatar: imageData,
                              baseInfo: userProfile.baseInfo.copyWith(
                                fullName: _nameController.text,
                              ),
                              openaiKey: _openaiKeyController.text,
                            );

                            userProfileBloc.add(
                              UserProfileUpdateEvent(newUserProfile),
                            );

                            setState(() {
                              _avatar = imageData;
                            });
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const VerticalDivider(),
                    TextFieldDecorated(
                      controller: _nameController,
                      labelText: "Full name",
                      hintText: "What is your full name?",
                      width: 400,
                    ),
                    const SizedBox(height: 20),
                    TextFieldDecorated(
                      controller: _nickNameController,
                      labelText: "Nickname",
                      hintText: "What is your preferred name or nickname?",
                      width: 400,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 400,
                      child: IntlPhoneField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          labelText: "Phone number",
                          hintText: "What is your phone number?",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        initialCountryCode: 'KG',
                        onChanged: (phone) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _communicationMethodController,
                      decoration: InputDecoration(
                        labelText: "Communication",
                        hintText:
                            "What is your preferred method of communication? (Email, WhatsApp, SMS, Other)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nationalityController,
                      decoration: InputDecoration(
                        labelText: "Nationality",
                        hintText: "What is your nationality?",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _openaiKeyController,
                      decoration: InputDecoration(
                        labelText: "OpenAI key",
                        error:
                            _openaiKeyController.text.isEmpty
                                ? Text("No API key provided")
                                : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: Text(
                            "Create API key here",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(color: Colors.blue),
                          ),
                          onTap:
                              () async => await launchUrl(
                                Uri.parse(
                                  'https://platform.openai.com/api-keys',
                                ),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 170,
                          child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<UserProfileBloc>(context).add(
                                UserProfileUpdateEvent(
                                  userProfile.copyWith(
                                    baseInfo: userProfile.baseInfo.copyWith(
                                      fullName: _nameController.text,
                                      nickName: _nickNameController.text,
                                      phoneNumber: _phoneNumberController.text,
                                      communicationMethod:
                                          _communicationMethodController.text,
                                      nationality: _nationalityController.text,
                                    ),
                                    openaiKey: _openaiKeyController.text,
                                  ),
                                ),
                              );

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Profile saved")),
                              );
                            },
                            child: const Text("Save profile"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
