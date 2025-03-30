import 'dart:typed_data';

import 'package:conciergego/bloc/events/settings_event.dart';
import 'package:conciergego/bloc/settings_bloc.dart';
import 'package:conciergego/bloc/states/settings_state.dart';
import 'package:conciergego/models/settings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsModel? _settings;

  Uint8List? _avatar;

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _openaiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final SettingsState state = BlocProvider.of<SettingsBloc>(context).state;

    if (state is SettingsLoadedState) {
      _settings = state.settings;
      _avatar = _settings?.avatar;
      _nameController.text = _settings?.userName ?? "";
      _openaiKeyController.text = _settings?.openaiKey ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                    if (_settings != null) {
                      _settings = _settings!.copyWith(
                        avatar: imageData,
                        userName: _nameController.text,
                        openaiKey: _openaiKeyController.text,
                      );

                      context.read<SettingsBloc>().add(
                        SettingsUpdateEvent(_settings!),
                      );

                      setState(() {
                        _avatar = imageData;
                      });
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const VerticalDivider(),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "User name",
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
                        Uri.parse('https://platform.openai.com/api-keys'),
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
                      if (_settings != null) {
                        BlocProvider.of<SettingsBloc>(context).add(
                          SettingsUpdateEvent(
                            _settings!.copyWith(
                              userName: _nameController.text,
                              openaiKey: _openaiKeyController.text,
                            ),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Changes saved")),
                        );
                      }
                    },
                    child: const Text("Save settings"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
