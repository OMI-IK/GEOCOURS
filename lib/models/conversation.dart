import 'message.dart';

class Conversation {
  final String id;
  final String title;
  final List<Message> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'messages': messages.map((m) => m.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final messagesJson = json['messages'] as List? ?? [];
    return Conversation(
      id: json['id'] as String,
      title: json['title'] as String,
      messages: messagesJson
          .map((m) => Message.fromJson(m as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Conversation copyWith({
    String? id,
    String? title,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static String generateTitle(List<Message> messages) {
    if (messages.isEmpty) return 'Nouvelle conversation';
    final firstUserMessage =
        messages.where((m) => m.isUser).firstOrNull?.content;
    if (firstUserMessage == null || firstUserMessage.isEmpty) {
      return 'Nouvelle conversation';
    }
    if (firstUserMessage.length > 40) {
      return '${firstUserMessage.substring(0, 40)}...';
    }
    return firstUserMessage;
  }
}
