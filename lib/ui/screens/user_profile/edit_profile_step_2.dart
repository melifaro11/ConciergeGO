import 'package:conciergego/ui/widgets/textfield_decorated.dart';
import 'package:flutter/material.dart';


class EditProfileStep2 extends StatefulWidget {
  final TextEditingController travelerTypeController;

  final TextEditingController travelFrequencyController;

  final TextEditingController accommodationPreferenceController;

  final TextEditingController hotelCategoryPreferenceController;

  final TextEditingController hotelLoyaltyMembershipsController;

  final TextEditingController preferredAirlineAndClassController;

  final TextEditingController frequentFlyerMembershipsController;

  final TextEditingController flightPreferenceController;

  final TextEditingController destinationTransportPreferenceController;

  final TextEditingController tourPreferenceController;

  final TextEditingController travelCompanionController;

  const EditProfileStep2({
    super.key,
    required this.travelerTypeController,
    required this.travelFrequencyController,
    required this.accommodationPreferenceController,
    required this.hotelCategoryPreferenceController,
    required this.hotelLoyaltyMembershipsController,
    required this.preferredAirlineAndClassController,
    required this.frequentFlyerMembershipsController,
    required this.flightPreferenceController,
    required this.destinationTransportPreferenceController,
    required this.tourPreferenceController,
    required this.travelCompanionController,
  });

  @override
  State<EditProfileStep2> createState() => _EditProfileStep1State();
}

class _EditProfileStep1State extends State<EditProfileStep2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldDecorated(
          controller: widget.travelerTypeController,
          labelText: "Travel type",
          hintText:
              "What type of traveler are you? (Business, Leisure, Digital Nomad, Luxury, Budget, Adventure, Family, Other)",
          //width: 400,
        ),
        const SizedBox(height: 20),
        TextFieldDecorated(
          controller: widget.travelFrequencyController,
          labelText: "Travel frequency",
          hintText:
              "How often do you travel? (Rarely, A few times a year, Monthly, Weekly)",
          //width: 400,
        ),
        const SizedBox(height: 20),
        TextFieldDecorated(
          controller: widget.accommodationPreferenceController,
          labelText: "Accommodations type",
          hintText:
              "What type of accommodations do you prefer? (Hotels, Airbnbs, Luxury Resorts, Hostels, Other)",
          //width: 400,
        ),
        const SizedBox(height: 20),
        TextFieldDecorated(
          controller: widget.hotelCategoryPreferenceController,
          labelText: "Hotel category",
          hintText:
              "What is your preferred hotel category? (5-star, 4-star, Boutique, Budget, No Preference)",
          //width: 400,
        ),
        const SizedBox(height: 20),
        TextFieldDecorated(
          controller: widget.hotelLoyaltyMembershipsController,
          labelText: "Hotel loyalty memberships",
          hintText:
              "Do you have any hotel loyalty memberships? If so, which ones?",
          //width: 400,
        ),
        const SizedBox(height: 20),
        TextFieldDecorated(
          controller: widget.preferredAirlineAndClassController,
          labelText: "Preferred airline and class",
          hintText:
              "What’s your preferred airline and seating class? (Economy, Premium Economy, Business, First Class)",
          //width: 400,
        ),
        const SizedBox(height: 20),
        TextFieldDecorated(
          controller: widget.frequentFlyerMembershipsController,
          labelText: "Frequent flyer memberships",
          hintText:
              "Do you have any frequent flyer memberships? If so, which ones?",
          //width: 400,
        ),
        const SizedBox(height: 20),
        TextFieldDecorated(
          controller: widget.flightPreferenceController,
          labelText: "Flight preference",
          hintText:
              "Do you prefer direct flights or are you open to layovers for cost savings?",
          //width: 400,
        ),
        const SizedBox(height: 20),
        TextFieldDecorated(
          controller: widget.destinationTransportPreferenceController,
          labelText: "Destination transportation preference",
          hintText:
              "What kind of transportation do you prefer at your destination? (Rental Car, Private Driver, Public Transport, Ride-Sharing)",
          //width: 400,
        ),
        const SizedBox(height: 20),
        TextFieldDecorated(
          controller: widget.tourPreferenceController,
          labelText: "Tour preference",
          hintText:
              "Do you enjoy guided tours or prefer self-guided experiences?",
          //width: 400,
        ),
        const SizedBox(height: 20),
        TextFieldDecorated(
          controller: widget.travelCompanionController,
          labelText: "Travel companion",
          hintText:
              "Do you usually travel solo, with a partner, family, or in a group?",
          //width: 400,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
