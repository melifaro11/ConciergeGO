import 'dart:convert';
import 'dart:typed_data';

/// UserProfile model
class UserProfileModel {
  final String? id;

  final String? userName;

  final Uint8List? avatar;

  final String openaiKey;

  final bool darkTheme;

  UserProfileModel(
      {required this.id,
      required this.userName,
      required this.avatar,
      required this.openaiKey,
      required this.darkTheme});

  UserProfileModel copyWith(
      {String? id,
      String? userName,
      Uint8List? avatar,
      String? openaiKey,
      bool? darkTheme}) {
    return UserProfileModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      avatar: avatar ?? this.avatar,
      openaiKey: openaiKey ?? this.openaiKey,
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }

  factory UserProfileModel.fromJson(String id, Map<String, dynamic> json) {
    return UserProfileModel(
      id: id,
      userName: json['userName'],
      avatar: json['avatar'] != null ? base64Decode(json['avatar']) : null,
      openaiKey: json['openaiKey'] ?? "",
      darkTheme: json['darkTheme'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'avatar': avatar != null ? base64Encode(avatar!.toList()) : null,
      'openaiKey': openaiKey,
      'darkTheme': darkTheme,
    };
  }
}
