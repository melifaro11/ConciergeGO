import 'package:conciergego/ui/widgets/textfield_decorated.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';

class EditProfileStep1 extends StatefulWidget {
  final TextEditingController nickNameController;

  final TextEditingController phoneNumberController;

  final TextEditingController openaiKeyController;

  final TextEditingController communicationMethodController;

  final TextEditingController nationalityController;

  const EditProfileStep1({
    super.key,
    required this.nickNameController,
    required this.phoneNumberController,
    required this.openaiKeyController,
    required this.communicationMethodController,
    required this.nationalityController,
  });

  @override
  State<EditProfileStep1> createState() => _EditProfileStep1State();
}

class _EditProfileStep1State extends State<EditProfileStep1> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldDecorated(
          controller: widget.nickNameController,
          labelText: "Nickname",
          hintText: "What is your preferred name or nickname?",
          width: 400,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 400,
          child: IntlPhoneField(
            controller: widget.phoneNumberController,
            decoration: InputDecoration(
              labelText: "Phone number",
              hintText: "What is your phone number?",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            initialCountryCode: 'KG',
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: widget.communicationMethodController,
          decoration: InputDecoration(
            labelText: "Communication",
            hintText:
                "What is your preferred method of communication? (Email, WhatsApp, SMS, Other)",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: widget.nationalityController,
          decoration: InputDecoration(
            labelText: "Nationality",
            hintText: "What is your nationality?",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: widget.openaiKeyController,
          decoration: InputDecoration(
            labelText: "API Key",
            hintText: "OpenAI API Key",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        const SizedBox(height: 20),

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
        const SizedBox(height: 15),
      ],
    );
  }
}
