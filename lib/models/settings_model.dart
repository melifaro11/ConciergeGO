import 'dart:convert';
import 'dart:typed_data';

/// Settings model
class SettingsModel {
  final String? id;

  final String? userName;

  final Uint8List? avatar;

  final String openaiKey;

  final bool darkTheme;

  SettingsModel(
      {required this.id,
      required this.userName,
      required this.avatar,
      required this.openaiKey,
      required this.darkTheme});

  SettingsModel copyWith(
      {String? id,
      String? userName,
      Uint8List? avatar,
      String? openaiKey,
      bool? darkTheme}) {
    return SettingsModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      avatar: avatar ?? this.avatar,
      openaiKey: openaiKey ?? this.openaiKey,
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }

  factory SettingsModel.fromJson(String id, Map<String, dynamic> json) {
    return SettingsModel(
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
