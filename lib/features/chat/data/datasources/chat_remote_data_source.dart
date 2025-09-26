import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/providers/app_providers.dart';
import '../models/chat_dto.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource(this._dio, {MockChatApi? mock}) : _mock = mock ?? MockChatApi.instance;

  final Dio _dio;
  final MockChatApi _mock;

  Future<List<ChatSummaryDto>> fetchChats() async {
    try {
      final response = await _dio.get<List<dynamic>>('/chats');
      final data = response.data ?? <dynamic>[];
      return data
          .map((item) => ChatSummaryDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException {
      return _mock.fetchChats();
    }
  }

  Future<List<ChatMessageDto>> fetchMessages({
    required String chatId,
    required int limit,
    DateTime? before,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/chats/$chatId/messages',
        queryParameters: {
          'limit': limit,
          if (before != null) 'before': before.toIso8601String(),
        },
      );
      final data = response.data ?? <dynamic>[];
      return data
          .map((item) => ChatMessageDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException {
      return _mock.fetchMessages(chatId: chatId, limit: limit, before: before);
    }
  }

  Future<ChatMessageDto> sendMessage({
    required String chatId,
    required String senderId,
    required String body,
    required List<PendingAttachmentPayload> attachments,
    required DateTime sentAt,
    String? clientMessageId,
  }) async {
    try {
      final payload = <String, dynamic>{
        'senderId': senderId,
        'body': body,
        'sentAt': sentAt.toIso8601String(),
        if (clientMessageId != null) 'clientMessageId': clientMessageId,
      };
      if (attachments.isNotEmpty) {
        final files = await Future.wait(
          attachments.map(
            (file) => MultipartFile.fromFile(
              file.path,
              filename: file.fileName,
              contentType: file.mimeType == null ? null : MediaTypeParser.tryParse(file.mimeType!),
            ),
          ),
        );
        final form = FormData.fromMap({
          ...payload,
          for (var i = 0; i < files.length; i++) 'files[$i]': files[i],
        });
        final response = await _dio.post<Map<String, dynamic>>(
          '/chats/$chatId/messages',
          data: form,
        );
        final data = response.data ?? <String, dynamic>{};
        return ChatMessageDto.fromJson(data);
      }
      final response = await _dio.post<Map<String, dynamic>>(
        '/chats/$chatId/messages',
        data: payload,
      );
      final data = response.data ?? <String, dynamic>{};
      return ChatMessageDto.fromJson(data);
    } on DioException {
      return _mock.sendMessage(
        chatId: chatId,
        senderId: senderId,
        body: body,
        sentAt: sentAt,
        attachments: attachments,
        clientMessageId: clientMessageId,
      );
    }
  }

  Future<void> markChatInWork(String chatId) async {
    try {
      await _dio.post<dynamic>(
        '/chats/$chatId/mark-in-work',
      );
    } on DioException {
      _mock.markChatInWork(chatId);
    }
  }
}

class PendingAttachmentPayload {
  PendingAttachmentPayload({
    required this.path,
    required this.fileName,
    required this.mimeType,
    required this.size,
  });

  final String path;
  final String fileName;
  final String? mimeType;
  final int? size;
}

class MockChatApi {
  MockChatApi._();

  static final MockChatApi instance = MockChatApi._();
  final Uuid _uuid = const Uuid();

  final Map<String, ChatSummaryDto> _chats = <String, ChatSummaryDto>{
    'chat-user-001': ChatSummaryDto(
      id: 'chat-user-001',
      userId: 'user-001',
      title: 'Студент Анастасия',
      status: 'new',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    'chat-user-002': ChatSummaryDto(
      id: 'chat-user-002',
      userId: 'user-002',
      title: 'Студент Иван',
      status: 'in_progress',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
  };

  final Map<String, List<ChatMessageDto>> _messages = <String, List<ChatMessageDto>>{};

  List<ChatSummaryDto> fetchChats() {
    return _chats.values.toList()
      ..sort((a, b) => (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt));
  }

  List<ChatMessageDto> fetchMessages({
    required String chatId,
    required int limit,
    DateTime? before,
  }) {
    final list = _messages.putIfAbsent(chatId, () => _seedMessages(chatId));
    final sorted = List<ChatMessageDto>.from(list)
      ..sort((a, b) => b.sentAt.compareTo(a.sentAt));
    final filtered = before == null
        ? sorted
        : sorted.where((message) => message.sentAt.isBefore(before)).toList();
    final slice = filtered.take(limit).toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return slice;
  }

  ChatMessageDto sendMessage({
    required String chatId,
    required String senderId,
    required String body,
    required DateTime sentAt,
    required List<PendingAttachmentPayload> attachments,
    String? clientMessageId,
  }) {
    final id = clientMessageId ?? _uuid.v4();
    final message = ChatMessageDto(
      id: id,
      chatId: chatId,
      senderId: senderId,
      body: body,
      messageType: attachments.isEmpty ? 'text' : 'attachment',
      isRead: senderId != 'user-001',
      sentAt: sentAt,
      attachments: attachments
          .map(
            (file) => ChatAttachmentDto(
              id: _uuid.v4(),
              messageId: id,
              url: file.path,
              mimeType: file.mimeType,
              size: file.size,
              createdAt: sentAt,
            ),
          )
          .toList(),
    );
    final list = _messages.putIfAbsent(chatId, () => _seedMessages(chatId));
    list.add(message);
    _chats.update(
      chatId,
      (chat) => ChatSummaryDto(
        id: chat.id,
        userId: chat.userId,
        title: chat.title,
        status: chat.status,
        createdAt: chat.createdAt,
        updatedAt: sentAt,
      ),
      ifAbsent: () => ChatSummaryDto(
        id: chatId,
        userId: senderId,
        title: 'Новый пользователь',
        status: 'new',
        createdAt: sentAt,
        updatedAt: sentAt,
      ),
    );
    return message;
  }

  void markChatInWork(String chatId) {
    final existing = _chats[chatId];
    if (existing != null) {
      _chats[chatId] = ChatSummaryDto(
        id: existing.id,
        userId: existing.userId,
        title: existing.title,
        status: 'in_progress',
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }

  List<ChatMessageDto> _seedMessages(String chatId) {
    final now = DateTime.now();
    return [
      ChatMessageDto(
        id: _uuid.v4(),
        chatId: chatId,
        senderId: _chats[chatId]?.userId ?? 'user-001',
        body: 'Здравствуйте! Хочу обсудить задание.',
        messageType: 'text',
        isRead: true,
        sentAt: now.subtract(const Duration(hours: 6)),
        attachments: const [],
      ),
      ChatMessageDto(
        id: _uuid.v4(),
        chatId: chatId,
        senderId: 'moderator-001',
        body: 'Добрый день! Уже смотрю вашу работу.',
        messageType: 'text',
        isRead: true,
        sentAt: now.subtract(const Duration(hours: 5, minutes: 40)),
        attachments: const [],
      ),
    ];
  }
}

class MediaTypeParser {
  static MediaType? tryParse(String raw) {
    final parts = raw.split('/');
    if (parts.length != 2) {
      return null;
    }
    return MediaType(parts.first, parts[1]);
  }
}

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatRemoteDataSource(dio);
});
