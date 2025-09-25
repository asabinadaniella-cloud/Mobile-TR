import 'package:tochka_rosta/core/database/app_database.dart';

class MessagesRepository {
  MessagesRepository(this._messagesDao);

  final MessagesDao _messagesDao;

  Future<void> upsertMessage(Message message) => _messagesDao.upsertMessage(message);

  Future<void> batchUpsertMessages(List<Message> messages) =>
      _messagesDao.insertMessagesBatch(messages);

  Future<List<Message>> paginateMessages(
    String chatId, {
    required int limit,
    DateTime? before,
  }) =>
      _messagesDao.fetchMessagesPage(chatId, limit: limit, before: before);
}
