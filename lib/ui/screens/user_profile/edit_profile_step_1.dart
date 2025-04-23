import 'package:conciergego/ui/widgets/textfield_decorated.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';

class EditProfileStep1 extends StatefulWidget {
  final TextEditingController nickNameController;

  final TextEditingController phoneNumberController;

  final TextEditingController openaiKeyController;

  final List<String> communicationMethods;

  final Function(List<String>) onCommunicationMethodsChanged;

  final String nationality;

  final Function(String) onNationalityChanged;

  const EditProfileStep1({
    super.key,
    required this.nickNameController,
    required this.phoneNumberController,
    required this.openaiKeyController,
    required this.communicationMethods,
    required this.onCommunicationMethodsChanged,
    required this.nationality,
    required this.onNationalityChanged,
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
        SizedBox(
          width: 400,
          child: CSCPickerPlus(
            countryStateLanguage: CountryStateLanguage.englishOrNative,
            currentCountry: widget.nationality,
            showStates: false,
            showCities: false,
            selectedItemStyle: Theme.of(context).textTheme.labelLarge,
            dropdownDecoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(15),
            ),
            onCountryChanged: (value) {
              widget.onNationalityChanged(value);
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Text("Preferred communication methods"),
            const SizedBox(width: 15),
            Wrap(
              spacing: 8,
              children:
                  ["phone", "sms", "email", "whatsapp/tg"].map((method) {
                    final isSelected = widget.communicationMethods.contains(
                      method,
                    );
                    return FilterChip(
                      label: Text(method.toUpperCase()),
                      selected: isSelected,
                      onSelected: (sel) {
                        if (sel) {
                          widget.communicationMethods.add(method);
                          debugPrint('Selected $method');
                        } else {
                          widget.communicationMethods.remove(method);
                          debugPrint('Unselected $method');
                        }

                        widget.onCommunicationMethodsChanged(
                          widget.communicationMethods,
                        );
                      },
                    );
                  }).toList(),
            ),
          ],
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
