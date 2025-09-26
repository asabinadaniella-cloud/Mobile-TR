import 'package:drift/drift.dart';

import 'package:tochka_rosta/core/database/app_database.dart';

class MessageWithAttachments {
  MessageWithAttachments({required this.message, required this.attachments});

  final Message message;
  final List<FileEntity> attachments;

  bool get isSynced => message.isSynced;
}

class MessagesRepository {
  MessagesRepository(this._messagesDao, this._filesDao);

  final MessagesDao _messagesDao;
  final FilesDao _filesDao;

  Future<void> upsertMessage(Message message) => _messagesDao.upsertMessage(message);

  Future<void> batchUpsertMessages(List<Message> messages) =>
      _messagesDao.insertMessagesBatch(messages);

  Future<List<Message>> paginateMessages(
    String chatId, {
    required int limit,
    DateTime? before,
  }) =>
      _messagesDao.fetchMessagesPage(chatId, limit: limit, before: before);

  Stream<List<MessageWithAttachments>> watchMessages(String chatId) {
    return _messagesDao.watchMessagesOrdered(chatId).asyncMap((messages) async {
      final grouped = await Future.wait(
        messages.map((message) async {
          final attachments = await _filesDao.filesForMessage(message.id);
          return MessageWithAttachments(message: message, attachments: attachments);
        }),
      );
      grouped.sort(
        (a, b) => a.message.sentAt.compareTo(b.message.sentAt),
      );
      return grouped;
    });
  }

  Future<List<Message>> unsyncedMessages(String chatId) =>
      _messagesDao.fetchUnsyncedMessages(chatId);

  Future<void> markSynced(String messageId) => _messagesDao.markMessageSynced(messageId);

  Future<void> deleteMessage(String messageId) => _messagesDao.deleteMessage(messageId);

  Future<void> saveAttachments(String messageId, List<FileEntity> attachments) async {
    if (attachments.isEmpty) {
      await _filesDao.deleteFilesForMessage(messageId);
      return;
    }
    await _filesDao.replaceFilesForMessage(
      messageId,
      attachments.map((file) => filesCompanionFor(file)).toList(),
    );
  }

  Future<List<FileEntity>> attachmentsForMessage(String messageId) =>
      _filesDao.filesForMessage(messageId);

  FilesCompanion filesCompanionFor(FileEntity file) {
    return FilesCompanion(
      id: Value(file.id),
      messageId: Value(file.messageId),
      ownerId: Value(file.ownerId),
      url: Value(file.url),
      mimeType: Value(file.mimeType),
      size: Value(file.size),
      createdAt: Value(file.createdAt),
    );
  }
}
