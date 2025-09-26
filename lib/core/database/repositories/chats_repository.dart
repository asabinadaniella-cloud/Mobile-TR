import 'package:drift/drift.dart';

import '../app_database.dart';

class ChatsRepository {
  ChatsRepository(this._dao);

  final ChatsDao _dao;

  Future<void> upsertChat(Chat chat) => _dao.upsertChat(chat);

  Future<List<Chat>> chatsForUser(String userId) => _dao.chatsForUser(userId);

  Stream<List<Chat>> watchAll() => _dao.watchChatsForModerator();

  Future<Chat?> findById(String chatId) => _dao.findById(chatId);

  Future<void> updateStatus(String chatId, String status) async {
    await (_dao.update(_dao.chats)..where((tbl) => tbl.id.equals(chatId))).write(
      ChatsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
