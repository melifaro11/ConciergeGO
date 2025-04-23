import 'dart:typed_data';

import 'package:conciergego/bloc/auth_bloc.dart';
import 'package:conciergego/bloc/events/user_profile_event.dart';
import 'package:conciergego/bloc/states/auth_state.dart';
import 'package:conciergego/bloc/user_profile_bloc.dart';
import 'package:conciergego/bloc/states/user_profile_state.dart';
import 'package:conciergego/ui/screens/login_screen.dart';
import 'package:conciergego/ui/screens/user_profile/edit_profile_step_1.dart';
import 'package:conciergego/ui/screens/user_profile/edit_profile_step_2.dart';
import 'package:conciergego/ui/widgets/elevated_icon_button.dart';
import 'package:conciergego/ui/widgets/textfield_decorated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileEditScreen extends StatefulWidget {
  static const routeName = '/user_profile_edit';

  const UserProfileEditScreen({super.key});

  @override
  State<UserProfileEditScreen> createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
  Uint8List? _avatar;

  final _nameController = TextEditingController();

  // Base info
  final _nickNameController = TextEditingController();

  final _phoneNumberController = TextEditingController();

  final _openaiKeyController = TextEditingController();

  List<String> _communicationMethod = [];

  // Preferences
  final _travelerTypeController = TextEditingController();

  final _travelFrequencyController = TextEditingController();

  final _accommodationPreferenceController = TextEditingController();

  final _hotelCategoryPreferenceController = TextEditingController();

  final _hotelLoyaltyMembershipsController = TextEditingController();

  final _preferredAirlineAndClassController = TextEditingController();

  final _frequentFlyerMembershipsController = TextEditingController();

  final _flightPreferenceController = TextEditingController();

  final _destinationTransportPreferenceController = TextEditingController();

  final _tourPreferenceController = TextEditingController();

  final _travelCompanionController = TextEditingController();

  int _currentStep = 0;

  String _nationality = "";

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

          _nickNameController.text = userProfile.baseInfo.nickName ?? "";
          _phoneNumberController.text = userProfile.baseInfo.phoneNumber ?? "";
          _openaiKeyController.text = userProfile.openaiKey;
          _communicationMethod = List.from(
            userProfile.baseInfo.communicationMethods ?? [],
          );
          _nationality = userProfile.baseInfo.nationality ?? "";

          return Scaffold(
            appBar: AppBar(
              title: const Text("My Profile"),
              automaticallyImplyLeading:
                  userProfile.baseInfo.fullName != null ? true : false,
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 58,
                        backgroundColor: Theme.of(context).primaryColorLight,
                        backgroundImage:
                            _avatar != null
                                ? Image.memory(_avatar!).image
                                : null,
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
                              );

                              userProfileBloc.add(
                                UserProfileSaveEvent(newUserProfile),
                              );

                              setState(() {
                                _avatar = imageData;
                              });
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextFieldDecorated(
                        controller: _nameController,
                        labelText: "Full name",
                        hintText: "What is your full name?",
                        width: 400,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Stepper(
                    currentStep: _currentStep,
                    type: StepperType.horizontal,
                    controlsBuilder: (context, details) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedIconButton(
                            onPressed: () {
                              BlocProvider.of<UserProfileBloc>(context).add(
                                UserProfileSaveEvent(
                                  userProfile.copyWith(
                                    openaiKey: _openaiKeyController.text,
                                    baseInfo: userProfile.baseInfo.copyWith(
                                      fullName: _nameController.text,
                                      nickName: _nickNameController.text,
                                      phoneNumber: _phoneNumberController.text,
                                      communicationMethods:
                                          _communicationMethod,
                                      nationality: _nationality,
                                    ),
                                    preferences: userProfile.preferences.copyWith(
                                      travelerType:
                                          _travelerTypeController.text,
                                      travelFrequency:
                                          _travelFrequencyController.text,
                                      accommodationPreference:
                                          _accommodationPreferenceController
                                              .text,
                                      hotelCategoryPreference:
                                          _hotelCategoryPreferenceController
                                              .text,
                                      hotelLoyaltyMemberships:
                                          _hotelLoyaltyMembershipsController
                                              .text,
                                      preferredAirlineAndClass:
                                          _preferredAirlineAndClassController
                                              .text,
                                      frequentFlyerMemberships:
                                          _frequentFlyerMembershipsController
                                              .text,
                                      flightPreference:
                                          _flightPreferenceController.text,
                                      destinationTransportPreference:
                                          _destinationTransportPreferenceController
                                              .text,
                                      tourPreference:
                                          _tourPreferenceController.text,
                                      travelCompanion:
                                          _travelCompanionController.text,
                                    ),
                                  ),
                                ),
                              );

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Profile saved")),
                              );
                            },
                            width: 200,
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withGreen(80),
                            child: const Text("Save profile"),
                          ),
                        ],
                      );
                    },
                    onStepTapped: (int index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    steps: <Step>[
                      Step(
                        title: const Text("Base info"),
                        content: EditProfileStep1(
                          openaiKeyController: _openaiKeyController,
                          nickNameController: _nickNameController,
                          phoneNumberController: _phoneNumberController,
                          communicationMethods: _communicationMethod,
                          onCommunicationMethodsChanged: (methods) {
                            BlocProvider.of<UserProfileBloc>(context).add(
                              UserProfileSaveEvent(
                                userProfile.copyWith(
                                  openaiKey: _openaiKeyController.text,
                                  baseInfo: userProfile.baseInfo.copyWith(
                                    nickName: _nickNameController.text,
                                    phoneNumber: _phoneNumberController.text,
                                    communicationMethods: methods,
                                    nationality: _nationality,
                                  ),
                                ),
                              ),
                            );
                          },
                          nationality: _nationality,
                          onNationalityChanged: (value) {
                            setState(() {
                              BlocProvider.of<UserProfileBloc>(context).add(
                                UserProfileSaveEvent(
                                  userProfile.copyWith(
                                    openaiKey: _openaiKeyController.text,
                                    baseInfo: userProfile.baseInfo.copyWith(
                                      nationality: value,
                                      nickName: _nickNameController.text,
                                      phoneNumber: _phoneNumberController.text,
                                      communicationMethods:
                                          _communicationMethod,
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ),
                      Step(
                        title: const Text("Travel preferences"),
                        content: EditProfileStep2(
                          travelerTypeController: _travelerTypeController,
                          travelFrequencyController: _travelFrequencyController,
                          accommodationPreferenceController:
                              _accommodationPreferenceController,
                          hotelCategoryPreferenceController:
                              _hotelCategoryPreferenceController,
                          hotelLoyaltyMembershipsController:
                              _hotelLoyaltyMembershipsController,
                          preferredAirlineAndClassController:
                              _preferredAirlineAndClassController,
                          frequentFlyerMembershipsController:
                              _frequentFlyerMembershipsController,
                          flightPreferenceController:
                              _flightPreferenceController,
                          destinationTransportPreferenceController:
                              _destinationTransportPreferenceController,
                          tourPreferenceController: _tourPreferenceController,
                          travelCompanionController: _travelCompanionController,
                        ),
                      ),
                      Step(
                        title: const Text("Preferences"),
                        content: Text("CCCC"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
