import 'dart:async';

import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tochka_rosta/core/database/app_database.dart';
import 'package:tochka_rosta/core/database/repositories/messages_repository.dart';

import '../../../core/providers/app_providers.dart';
import '../data/chat_providers.dart';
import '../data/chat_repository.dart';
import '../data/datasources/chat_remote_data_source.dart';
import '../domain/chat_models.dart';

enum ChatMode { user, moderator }

class PendingAttachment {
  PendingAttachment({
    required this.path,
    required this.name,
    this.mimeType,
    this.size,
  });

  final String path;
  final String name;
  final String? mimeType;
  final int? size;
}

class ChatState {
  ChatState({
    required this.mode,
    required this.selectedChatId,
    this.messages = const [],
    this.availableChats = const [],
    this.pendingAttachments = const [],
    this.isLoading = true,
    this.isSending = false,
    this.isFetchingMore = false,
    this.hasMore = true,
    this.isModeratorTyping = false,
    this.isMarkingInWork = false,
    this.errorMessage,
  });

  final ChatMode mode;
  final String? selectedChatId;
  final List<ChatMessageView> messages;
  final List<ChatSummaryView> availableChats;
  final List<PendingAttachment> pendingAttachments;
  final bool isLoading;
  final bool isSending;
  final bool isFetchingMore;
  final bool hasMore;
  final bool isModeratorTyping;
  final bool isMarkingInWork;
  final String? errorMessage;

  ChatState copyWith({
    ChatMode? mode,
    String? selectedChatId,
    List<ChatMessageView>? messages,
    List<ChatSummaryView>? availableChats,
    List<PendingAttachment>? pendingAttachments,
    bool? isLoading,
    bool? isSending,
    bool? isFetchingMore,
    bool? hasMore,
    bool? isModeratorTyping,
    bool? isMarkingInWork,
    String? errorMessage,
  }) {
    return ChatState(
      mode: mode ?? this.mode,
      selectedChatId: selectedChatId ?? this.selectedChatId,
      messages: messages ?? this.messages,
      availableChats: availableChats ?? this.availableChats,
      pendingAttachments: pendingAttachments ?? this.pendingAttachments,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasMore: hasMore ?? this.hasMore,
      isModeratorTyping: isModeratorTyping ?? this.isModeratorTyping,
      isMarkingInWork: isMarkingInWork ?? this.isMarkingInWork,
      errorMessage: errorMessage,
    );
  }
}

final chatCurrentUserIdProvider = Provider<String>((ref) => 'user-001');
final chatModeratorIdProvider = Provider<String>((ref) => 'moderator-001');
final chatDefaultChatIdProvider = Provider<String>((ref) => 'chat-user-001');

class ChatController extends StateNotifier<ChatState> {
  ChatController(this.ref, this._repository)
      : super(ChatState(mode: ChatMode.user, selectedChatId: ref.read(chatDefaultChatIdProvider))) {
    _initialize();
  }

  static const _pageSize = 20;

  final Ref ref;
  final ChatRepository _repository;

  StreamSubscription<List<MessageWithAttachments>>? _messagesSub;
  StreamSubscription<List<Chat>>? _chatsSub;
  Timer? _typingTimer;
  Timer? _outboxTimer;

  Future<void> _initialize() async {
    final chatId = state.selectedChatId;
    if (chatId == null) {
      return;
    }
    final userId = ref.read(chatCurrentUserIdProvider);
    await _repository.ensureChatExists(chatId: chatId, userId: userId);
    _listenToMessages(chatId);
    final loaded = await _repository.loadMoreMessages(chatId: chatId, limit: _pageSize);
    _updateHasMore(loaded.length);
    await _repository.processOutbox(chatId, userId);
    _scheduleOutbox(chatId, userId);
    _listenToModeratorChats();
    await _repository.hydrateChatsForModerator();
    await _logEvent('chat_opened', chatId: chatId, mode: state.mode);
    state = state.copyWith(isLoading: false);
  }

  void _listenToMessages(String chatId) {
    _messagesSub?.cancel();
    _messagesSub = _repository.watchMessages(chatId).listen((entries) {
      final currentUserId = ref.read(chatCurrentUserIdProvider);
      final moderatorId = ref.read(chatModeratorIdProvider);
      final selectedChat = state.availableChats.firstWhereOrNull((chat) => chat.id == chatId);
      final userOwnerId = state.mode == ChatMode.moderator
          ? selectedChat?.userId ?? currentUserId
          : currentUserId;

      final messages = entries
          .map(
            (entry) => ChatMessageView(
              id: entry.message.id,
              chatId: entry.message.chatId,
              senderId: entry.message.senderId,
              body: entry.message.body,
              messageType: entry.message.messageType,
              sentAt: entry.message.sentAt,
              isMine: state.mode == ChatMode.moderator
                  ? entry.message.senderId == moderatorId
                  : entry.message.senderId == userOwnerId,
              isModerator: entry.message.senderId == moderatorId,
              isSynced: entry.message.isSynced,
              attachments: entry.attachments.map(mapFileEntityToAttachment).toList(),
            ),
          )
          .toList();
      state = state.copyWith(messages: messages, isLoading: false, errorMessage: null);
    });
  }

  void _listenToModeratorChats() {
    _chatsSub?.cancel();
    _chatsSub = ref.read(chatsRepositoryProvider).watchAll().listen((chats) {
      final summaries = chats
          .map(
            (chat) => ChatSummaryView(
              id: chat.id,
              userId: chat.userId,
              title: chat.title,
              status: chat.status,
              updatedAt: chat.updatedAt,
            ),
          )
          .toList();
      state = state.copyWith(availableChats: summaries);
      if (state.mode == ChatMode.moderator) {
        final current = state.selectedChatId;
        if (current == null || summaries.every((chat) => chat.id != current)) {
          final firstChat = summaries.firstOrNull;
          if (firstChat != null) {
            _switchChat(firstChat.id);
          }
        }
      }
    });
  }

  Future<void> setMode(ChatMode mode) async {
    if (state.mode == mode) {
      return;
    }
    final analytics = ref.read(firebaseAnalyticsProvider);
    analytics?.logEvent(
      name: 'chat_mode_changed',
      parameters: {'mode': mode.name},
    );
    final chatId = mode == ChatMode.user
        ? ref.read(chatDefaultChatIdProvider)
        : state.availableChats.firstOrNull?.id ?? state.selectedChatId;
    state = state.copyWith(mode: mode, selectedChatId: chatId, isLoading: true);
    if (chatId != null) {
      _listenToMessages(chatId);
      final loaded = await _repository.loadMoreMessages(chatId: chatId, limit: _pageSize);
      _updateHasMore(loaded.length);
      await _logEvent('chat_opened', chatId: chatId, mode: mode);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> selectChat(String chatId) async {
    if (state.selectedChatId == chatId) {
      return;
    }
    await _switchChat(chatId);
  }

  Future<void> _switchChat(String chatId) async {
    final senderId = state.mode == ChatMode.moderator
        ? ref.read(chatModeratorIdProvider)
        : ref.read(chatCurrentUserIdProvider);
    state = state.copyWith(selectedChatId: chatId, isLoading: true);
    _listenToMessages(chatId);
    final loaded = await _repository.loadMoreMessages(chatId: chatId, limit: _pageSize);
    _updateHasMore(loaded.length);
    await _repository.processOutbox(chatId, senderId);
    _scheduleOutbox(chatId, senderId);
    await _logEvent('chat_opened', chatId: chatId, mode: state.mode);
    state = state.copyWith(isLoading: false);
  }

  Future<void> loadMore() async {
    if (state.isFetchingMore || !state.hasMore) {
      return;
    }
    final chatId = state.selectedChatId;
    if (chatId == null) {
      return;
    }
    state = state.copyWith(isFetchingMore: true);
    final before = state.messages.isEmpty ? DateTime.now() : state.messages.first.sentAt;
    final loaded = await _repository.loadMoreMessages(
      chatId: chatId,
      limit: _pageSize,
      before: before,
    );
    _updateHasMore(loaded.length);
    state = state.copyWith(isFetchingMore: false);
  }

  Future<void> sendMessage(String text) async {
    final chatId = state.selectedChatId;
    if (chatId == null) {
      return;
    }
    final trimmed = text.trim();
    if (trimmed.isEmpty && state.pendingAttachments.isEmpty) {
      return;
    }
    state = state.copyWith(isSending: true);
    final senderId = state.mode == ChatMode.moderator
        ? ref.read(chatModeratorIdProvider)
        : ref.read(chatCurrentUserIdProvider);
    final payloadAttachments = state.pendingAttachments
        .map(
          (file) => PendingAttachmentPayload(
            path: file.path,
            fileName: file.name,
            mimeType: file.mimeType,
            size: file.size,
          ),
        )
        .toList();
    try {
      await _repository.sendMessage(
        chatId: chatId,
        senderId: senderId,
        body: trimmed,
        attachments: payloadAttachments,
      );
      await _repository.processOutbox(chatId, senderId);
      await _logEvent(
        'message_sent',
        chatId: chatId,
        mode: state.mode,
        attachmentCount: payloadAttachments.length,
      );
      state = state.copyWith(pendingAttachments: [], errorMessage: null);
      if (state.mode == ChatMode.user) {
        _simulateModeratorTyping();
      }
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
      await _logEvent(
        'message_send_error',
        chatId: chatId,
        mode: state.mode,
        attachmentCount: payloadAttachments.length,
      );
    } finally {
      state = state.copyWith(isSending: false);
    }
  }

  void addAttachments(List<PendingAttachment> attachments) {
    if (attachments.isEmpty) {
      return;
    }
    final updated = List<PendingAttachment>.from(state.pendingAttachments)..addAll(attachments);
    state = state.copyWith(pendingAttachments: updated);
  }

  void removeAttachment(PendingAttachment attachment) {
    final updated = List<PendingAttachment>.from(state.pendingAttachments)
      ..removeWhere((item) => item.path == attachment.path);
    state = state.copyWith(pendingAttachments: updated);
  }

  Future<void> markChatInWork() async {
    final chatId = state.selectedChatId;
    if (chatId == null) {
      return;
    }
    state = state.copyWith(isMarkingInWork: true);
    try {
      await _repository.markChatInWork(chatId);
      final updatedChats = state.availableChats
          .map((chat) => chat.id == chatId ? chat.copyWith(status: 'in_progress', updatedAt: DateTime.now()) : chat)
          .toList();
      state = state.copyWith(availableChats: updatedChats);
      await _logEvent('chat_mark_in_work', chatId: chatId, mode: state.mode);
    } finally {
      state = state.copyWith(isMarkingInWork: false);
    }
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  void _updateHasMore(int loadedCount) {
    state = state.copyWith(hasMore: loadedCount >= _pageSize);
  }

  void _simulateModeratorTyping() {
    _typingTimer?.cancel();
    state = state.copyWith(isModeratorTyping: true);
    _typingTimer = Timer(const Duration(seconds: 3), () {
      state = state.copyWith(isModeratorTyping: false);
    });
  }

  void _scheduleOutbox(String chatId, String senderId) {
    _outboxTimer?.cancel();
    _outboxTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(_repository.processOutbox(chatId, senderId));
    });
  }

  Future<void> _logEvent(
    String name, {
    required String chatId,
    required ChatMode mode,
    int attachmentCount = 0,
  }) async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    await analytics?.logEvent(
      name: name,
      parameters: {
        'mode': mode.name,
        'chat_id': chatId,
        'attachments': attachmentCount,
      },
    );
  }

  @override
  void dispose() {
    _messagesSub?.cancel();
    _chatsSub?.cancel();
    _typingTimer?.cancel();
    _outboxTimer?.cancel();
    super.dispose();
  }
}

final chatControllerProvider = StateNotifierProvider<ChatController, ChatState>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatController(ref, repository);
});
