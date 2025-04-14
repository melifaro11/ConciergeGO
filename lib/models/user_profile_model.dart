import 'dart:convert';
import 'dart:typed_data';

/// UserProfile model
class UserProfileModel {
  final String? id;

  final Uint8List? avatar;

  final String openaiKey;

  final bool darkTheme;

  final int profileType;

  final UserBaseInfoModel baseInfo;

  final UserPreferencesModel preferences;

  UserProfileModel({
    required this.id,
    required this.avatar,
    required this.openaiKey,
    required this.darkTheme,
    required this.profileType,
    required this.baseInfo,
    required this.preferences,
  });

  UserProfileModel copyWith({
    String? id,
    Uint8List? avatar,
    String? openaiKey,
    bool? darkTheme,
    int? profileType,
    UserBaseInfoModel? baseInfo,
    UserPreferencesModel? preferences,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      openaiKey: openaiKey ?? this.openaiKey,
      darkTheme: darkTheme ?? this.darkTheme,
      profileType: profileType ?? this.profileType,
      baseInfo: baseInfo ?? this.baseInfo,
      preferences: preferences ?? this.preferences,
    );
  }

  factory UserProfileModel.fromJson(String id, Map<String, dynamic> json) {
    return UserProfileModel(
      id: id,
      avatar: json['avatar'] != null ? base64Decode(json['avatar']) : null,
      openaiKey: json['openaiKey'] ?? "",
      darkTheme: json['darkTheme'] ?? true,
      profileType: json['profileType'] ?? 0,
      baseInfo: UserBaseInfoModel.fromJson(json),
      preferences: UserPreferencesModel.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
        'avatar': avatar != null ? base64Encode(avatar!.toList()) : null,
        'openaiKey': openaiKey,
        'darkTheme': darkTheme,
        'profileType': profileType,
      }
      ..addAll(baseInfo.toJson())
      ..addAll(preferences.toJson());
  }
}

class UserBaseInfoModel {
  final String? fullName;

  final String? nickName;

  final String? phoneNumber;

  final String? communicationMethod;

  final List<String>? languages;

  final String? nationality;

  UserBaseInfoModel({
    this.fullName,
    this.nickName,
    this.phoneNumber,
    this.communicationMethod,
    this.languages,
    this.nationality,
  });

  UserBaseInfoModel copyWith({
    String? fullName,
    String? nickName,
    String? phoneNumber,
    String? communicationMethod,
    List<String>? languages,
    String? nationality,
  }) {
    return UserBaseInfoModel(
      fullName: fullName ?? this.fullName,
      nickName: nickName ?? this.nickName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      communicationMethod: communicationMethod ?? this.communicationMethod,
      languages: languages ?? this.languages,
      nationality: nationality ?? this.nationality,
    );
  }

  factory UserBaseInfoModel.fromJson(Map<String, dynamic> json) {
    return UserBaseInfoModel(
      fullName: json['fullName'],
      nickName: json['nickName'],
      phoneNumber: json['phoneNumber'],
      communicationMethod: json['communicationMethod'],
      languages: json['languages'],
      nationality: json['nationality'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'nickName': nickName,
      'phoneNumber': phoneNumber,
      'communicationMethod': communicationMethod,
      'languages': languages,
      'nationality': nationality,
    };
  }
}

class UserPreferencesModel {
  final String? travelerType;

  final String? travelFrequency;

  final String? accommodationPreference;

  final String? hotelCategoryPreference;

  final String? hotelLoyaltyMemberships;

  final String? preferredAirlineAndClass;

  final String? frequentFlyerMemberships;

  final String? flightPreference;

  final String? destinationTransportPreference;

  final String? tourPreference;

  final String? travelCompanion;

  UserPreferencesModel({
    this.travelerType,
    this.travelFrequency,
    this.accommodationPreference,
    this.hotelCategoryPreference,
    this.hotelLoyaltyMemberships,
    this.preferredAirlineAndClass,
    this.frequentFlyerMemberships,
    this.flightPreference,
    this.destinationTransportPreference,
    this.tourPreference,
    this.travelCompanion,
  });

  UserPreferencesModel copyWith({
    String? travelerType,
    String? travelFrequency,
    String? accommodationPreference,
    String? hotelCategoryPreference,
    String? hotelLoyaltyMemberships,
    String? preferredAirlineAndClass,
    String? frequentFlyerMemberships,
    String? flightPreference,
    String? destinationTransportPreference,
    String? tourPreference,
    String? travelCompanion,
  }) {
    return UserPreferencesModel(
      travelerType: travelerType ?? this.travelerType,
      travelFrequency: travelFrequency ?? this.travelFrequency,
      accommodationPreference:
          accommodationPreference ?? this.accommodationPreference,
      hotelCategoryPreference:
          hotelCategoryPreference ?? this.hotelCategoryPreference,
      hotelLoyaltyMemberships:
          hotelLoyaltyMemberships ?? this.hotelLoyaltyMemberships,
      preferredAirlineAndClass:
          preferredAirlineAndClass ?? this.preferredAirlineAndClass,
      frequentFlyerMemberships:
          frequentFlyerMemberships ?? this.frequentFlyerMemberships,
      flightPreference: flightPreference ?? this.flightPreference,
      destinationTransportPreference:
          destinationTransportPreference ?? this.destinationTransportPreference,
      tourPreference: tourPreference ?? this.tourPreference,
      travelCompanion: travelCompanion ?? this.travelCompanion,
    );
  }

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      travelerType: json['travelerType'],
      travelFrequency: json['travelFrequency'],
      accommodationPreference: json['accommodationPreference'],
      hotelCategoryPreference: json['hotelCategoryPreference'],
      hotelLoyaltyMemberships: json['hotelLoyaltyMemberships'],
      preferredAirlineAndClass: json['preferredAirlineAndClass'],
      frequentFlyerMemberships: json['frequentFlyerMemberships'],
      flightPreference: json['flightPreference'],
      destinationTransportPreference: json['destinationTransportPreference'],
      tourPreference: json['tourPreference'],
      travelCompanion: json['travelCompanion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'travelerType': travelerType,
      'travelFrequency': travelFrequency,
      'accommodationPreference': accommodationPreference,
      'hotelCategoryPreference': hotelCategoryPreference,
      'hotelLoyaltyMemberships': hotelLoyaltyMemberships,
      'preferredAirlineAndClass': preferredAirlineAndClass,
      'frequentFlyerMemberships': frequentFlyerMemberships,
      'flightPreference': flightPreference,
      'destinationTransportPreference': destinationTransportPreference,
      'tourPreference': tourPreference,
      'travelCompanion': travelCompanion,
    };
  }
}
