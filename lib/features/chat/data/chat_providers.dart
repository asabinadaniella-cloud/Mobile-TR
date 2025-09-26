import 'package:riverpod/riverpod.dart';
import 'package:tochka_rosta/core/database/app_database.dart';
import 'package:tochka_rosta/core/database/repositories/chats_repository.dart';
import 'package:tochka_rosta/core/database/repositories/messages_repository.dart';
import 'package:tochka_rosta/core/providers/app_providers.dart';

import 'chat_repository.dart';
import 'datasources/chat_remote_data_source.dart';

final chatsRepositoryProvider = Provider<ChatsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ChatsRepository(ChatsDao(db));
});

final messagesRepositoryProvider = Provider<MessagesRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return MessagesRepository(MessagesDao(db), FilesDao(db));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final remote = ref.watch(chatRemoteDataSourceProvider);
  final messagesRepository = ref.watch(messagesRepositoryProvider);
  final chatsRepository = ref.watch(chatsRepositoryProvider);
  return ChatRepository(remote, messagesRepository, chatsRepository);
});
