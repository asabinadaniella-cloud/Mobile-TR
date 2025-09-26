import 'package:equatable/equatable.dart';

class ChatSummaryDto extends Equatable {
  const ChatSummaryDto({
    required this.id,
    required this.userId,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String? title;
  final String? status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory ChatSummaryDto.fromJson(Map<String, dynamic> json) {
    return ChatSummaryDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String?,
      status: json['status'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, userId, title, status, createdAt, updatedAt];
}

class ChatAttachmentDto extends Equatable {
  const ChatAttachmentDto({
    required this.id,
    required this.messageId,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.createdAt,
  });

  final String id;
  final String messageId;
  final String url;
  final String? mimeType;
  final int? size;
  final DateTime createdAt;

  factory ChatAttachmentDto.fromJson(Map<String, dynamic> json) {
    return ChatAttachmentDto(
      id: json['id'] as String,
      messageId: json['messageId'] as String,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String?,
      size: json['size'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'messageId': messageId,
        'url': url,
        'mimeType': mimeType,
        'size': size,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, messageId, url, mimeType, size, createdAt];
}

class ChatMessageDto extends Equatable {
  const ChatMessageDto({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.body,
    required this.messageType,
    required this.isRead,
    required this.sentAt,
    required this.attachments,
  });

  final String id;
  final String chatId;
  final String senderId;
  final String body;
  final String messageType;
  final bool isRead;
  final DateTime sentAt;
  final List<ChatAttachmentDto> attachments;

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    final attachments = (json['attachments'] as List<dynamic>? ?? <dynamic>[])
        .map((item) => ChatAttachmentDto.fromJson(item as Map<String, dynamic>))
        .toList();
    return ChatMessageDto(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      body: json['body'] as String,
      messageType: json['messageType'] as String,
      isRead: (json['isRead'] as bool?) ?? true,
      sentAt: DateTime.parse(json['sentAt'] as String),
      attachments: attachments,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': chatId,
        'senderId': senderId,
        'body': body,
        'messageType': messageType,
        'isRead': isRead,
        'sentAt': sentAt.toIso8601String(),
        'attachments': attachments.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [id, chatId, senderId, body, messageType, isRead, sentAt, attachments];
}
