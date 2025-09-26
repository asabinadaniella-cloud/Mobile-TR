import 'package:equatable/equatable.dart';
import 'package:tochka_rosta/core/database/app_database.dart';

class ChatAttachment extends Equatable {
  const ChatAttachment({
    required this.id,
    required this.messageId,
    required this.url,
    required this.mimeType,
    required this.size,
  });

  final String id;
  final String messageId;
  final String? mimeType;
  final String url;
  final int? size;

  @override
  List<Object?> get props => [id, messageId, url, mimeType, size];
}

class ChatMessageView extends Equatable {
  const ChatMessageView({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.body,
    required this.messageType,
    required this.sentAt,
    required this.isMine,
    required this.isModerator,
    required this.isSynced,
    required this.attachments,
  });

  final String id;
  final String chatId;
  final String senderId;
  final String body;
  final String messageType;
  final DateTime sentAt;
  final bool isMine;
  final bool isModerator;
  final bool isSynced;
  final List<ChatAttachment> attachments;

  bool get hasAttachments => attachments.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        chatId,
        senderId,
        body,
        messageType,
        sentAt,
        isMine,
        isModerator,
        isSynced,
        attachments,
      ];
}

class ChatSummaryView extends Equatable {
  const ChatSummaryView({
    required this.id,
    required this.userId,
    required this.title,
    required this.status,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String? title;
  final String? status;
  final DateTime? updatedAt;

  bool get isInProgress => status == 'in_progress';

  ChatSummaryView copyWith({
    String? status,
    DateTime? updatedAt,
  }) {
    return ChatSummaryView(
      id: id,
      userId: userId,
      title: title,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, title, status, updatedAt];
}

ChatAttachment mapFileEntityToAttachment(FileEntity entity) {
  return ChatAttachment(
    id: entity.id,
    messageId: entity.messageId ?? entity.id,
    url: entity.url,
    mimeType: entity.mimeType,
    size: entity.size,
  );
}
