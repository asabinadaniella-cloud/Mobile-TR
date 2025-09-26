import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:tochka_rosta/core/database/app_database.dart';
import 'package:tochka_rosta/core/database/repositories/chats_repository.dart';
import 'package:tochka_rosta/core/database/repositories/messages_repository.dart';

import 'datasources/chat_remote_data_source.dart';
import 'models/chat_dto.dart';

typedef MessageQueueEntry = MessageWithAttachments;

class ChatRepository {
  ChatRepository(
    this._remote,
    this._messagesRepository,
    this._chatsRepository,
  );

  final ChatRemoteDataSource _remote;
  final MessagesRepository _messagesRepository;
  final ChatsRepository _chatsRepository;
  final Uuid _uuid = const Uuid();

  Stream<List<MessageWithAttachments>> watchMessages(String chatId) {
    return _messagesRepository.watchMessages(chatId);
  }

  Future<void> syncLatestMessages(String chatId, {int limit = 50}) async {
    await loadMoreMessages(chatId: chatId, limit: limit);
  }

  Future<List<MessageWithAttachments>> loadMoreMessages({
    required String chatId,
    required int limit,
    DateTime? before,
  }) async {
    final remoteMessages = await _remote.fetchMessages(
      chatId: chatId,
      limit: limit,
      before: before,
    );
    if (remoteMessages.isEmpty) {
      return const [];
    }
    final entries = remoteMessages.map(_mapDtoToMessage).toList();
    await _messagesRepository.batchUpsertMessages(entries.map((e) => e.message).toList());
    for (final entry in entries) {
      await _messagesRepository.saveAttachments(entry.message.id, entry.attachments);
    }
    return entries;
  }

  Future<void> hydrateChatsForModerator() async {
    final chats = await _remote.fetchChats();
    if (chats.isEmpty) {
      return;
    }
    for (final chat in chats) {
      await _chatsRepository.upsertChat(_mapSummaryToEntity(chat));
    }
  }

  Future<Chat> ensureChatExists({
    required String chatId,
    required String userId,
  }) async {
    final existing = await _chatsRepository.findById(chatId);
    if (existing != null) {
      return existing;
    }
    final now = DateTime.now();
    final chat = Chat(
      id: chatId,
      userId: userId,
      title: 'Чат пользователя',
      status: 'new',
      createdAt: now,
      updatedAt: now,
    );
    await _chatsRepository.upsertChat(chat);
    return chat;
  }

  Future<MessageWithAttachments> queueOutgoingMessage({
    required String chatId,
    required String senderId,
    required String body,
    required List<PendingAttachmentPayload> attachments,
    DateTime? sentAt,
  }) async {
    final messageId = _uuid.v4();
    final timestamp = sentAt ?? DateTime.now();
    final message = Message(
      id: messageId,
      chatId: chatId,
      senderId: senderId,
      body: body,
      messageType: attachments.isEmpty ? 'text' : 'attachment',
      isRead: senderId != chatId,
      isSynced: false,
      sentAt: timestamp,
      updatedAt: timestamp,
    );
    await _messagesRepository.upsertMessage(message);
    final fileEntities = attachments
        .map(
          (file) => FileEntity(
            id: _uuid.v4(),
            messageId: messageId,
            ownerId: senderId,
            url: file.path,
            mimeType: file.mimeType,
            size: file.size,
            createdAt: timestamp,
          ),
        )
        .toList();
    await _messagesRepository.saveAttachments(messageId, fileEntities);
    return MessageWithAttachments(message: message, attachments: fileEntities);
  }

  Future<MessageWithAttachments> sendMessage({
    required String chatId,
    required String senderId,
    required String body,
    required List<PendingAttachmentPayload> attachments,
    DateTime? sentAt,
  }) async {
    final queued = await queueOutgoingMessage(
      chatId: chatId,
      senderId: senderId,
      body: body,
      attachments: attachments,
      sentAt: sentAt,
    );
    try {
      final remoteMessage = await _remote.sendMessage(
        chatId: chatId,
        senderId: senderId,
        body: body,
        sentAt: queued.message.sentAt,
        attachments: attachments,
        clientMessageId: queued.message.id,
      );
      await _persistRemoteMessage(remoteMessage);
      await _messagesRepository.markSynced(queued.message.id);
      final mapped = _mapDtoToMessage(remoteMessage);
      await _messagesRepository.upsertMessage(mapped.message);
      await _messagesRepository.saveAttachments(mapped.message.id, mapped.attachments);
      return mapped;
    } catch (_) {
      return queued;
    }
  }

  Future<void> processOutbox(String chatId, String senderId) async {
    final pending = await _messagesRepository.unsyncedMessages(chatId);
    if (pending.isEmpty) {
      return;
    }
    for (final message in pending) {
      final attachments = await _messagesRepository.attachmentsForMessage(message.id);
      try {
        final dto = await _remote.sendMessage(
          chatId: chatId,
          senderId: senderId,
          body: message.body,
          sentAt: message.sentAt,
          attachments: attachments
              .map(
                (file) => PendingAttachmentPayload(
                  path: file.url,
                  fileName: file.url.split('/').last,
                  mimeType: file.mimeType,
                  size: file.size,
                ),
              )
              .toList(),
          clientMessageId: message.id,
        );
        await _persistRemoteMessage(dto);
      } catch (_) {
        continue;
      }
    }
  }

  Future<void> markChatInWork(String chatId) async {
    await _remote.markChatInWork(chatId);
    await _chatsRepository.updateStatus(chatId, 'in_progress');
  }

  Chat _mapSummaryToEntity(ChatSummaryDto dto) {
    return Chat(
      id: dto.id,
      userId: dto.userId,
      title: dto.title,
      status: dto.status,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  MessageWithAttachments _mapDtoToMessage(ChatMessageDto dto) {
    final message = Message(
      id: dto.id,
      chatId: dto.chatId,
      senderId: dto.senderId,
      body: dto.body,
      messageType: dto.messageType,
      isRead: dto.isRead,
      isSynced: true,
      sentAt: dto.sentAt,
      updatedAt: dto.sentAt,
    );
    final attachments = dto.attachments
        .map(
          (attachment) => FileEntity(
            id: attachment.id,
            messageId: dto.id,
            ownerId: dto.senderId,
            url: attachment.url,
            mimeType: attachment.mimeType,
            size: attachment.size,
            createdAt: attachment.createdAt,
          ),
        )
        .toList();
    return MessageWithAttachments(message: message, attachments: attachments);
  }

  Future<void> _persistRemoteMessage(ChatMessageDto dto) async {
    final mapped = _mapDtoToMessage(dto);
    await _messagesRepository.upsertMessage(mapped.message);
    await _messagesRepository.saveAttachments(mapped.message.id, mapped.attachments);
  }
}
