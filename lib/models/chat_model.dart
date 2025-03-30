/// Message model
class MessageModel {
  /// Message body
  final String content;

  /// Message role: user, assistant, system
  final String role;

  MessageModel({
    required this.content,
    required this.role,
  });

  MessageModel copyWith({
    String? content,
    String? role,
  }) {
    return MessageModel(
      content: content ?? this.content,
      role: role ?? this.role,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      content: json['content'],
      role: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'type': role,
    };
  }
}

/// Chat model
class ChatModel {
  /// Assistant's Firestore ID
  final String? id;

  /// Chat name
  final String name;

  /// Messages
  final List<MessageModel> messages;

  ChatModel({
    required this.id,
    required this.name,
    required this.messages,
  });

  ChatModel copyWith({
    String? id,
    String? name,
    List<MessageModel>? messages,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      messages: messages ?? this.messages,
    );
  }

  factory ChatModel.fromJson(String id, Map<String, dynamic> json) {
    return ChatModel(
      id: id,
      name: json['name'] ?? "",
      messages: List<MessageModel>.from(json['messages']
          .map((message) => MessageModel.fromJson(message))
          .toList()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}
