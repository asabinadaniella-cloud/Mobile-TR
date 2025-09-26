import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../../features/chat/application/chat_controller.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/results/presentation/pages/results_page.dart';

final pushNotificationsServiceProvider = Provider<PushNotificationsService>((ref) {
  final dio = ref.watch(dioProvider);
  return PushNotificationsService(ref, dio);
});

final pushNotificationsInitializerProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(pushNotificationsServiceProvider);
  await service.initialize();
});

class PushNotificationsService {
  PushNotificationsService(this.ref, this._dio);

  final Ref ref;
  final Dio _dio;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    debugPrint(
      'Push notifications are disabled because Firebase Cloud Messaging is not available.',
    );
    _initialized = true;
    ref.onDispose(_dispose);
  }

  Future<void> registerToken(String token) async {
    try {
      await _dio.post<dynamic>(
        '/push/register',
        data: <String, dynamic>{'token': token},
      );
    } on DioException catch (error, stackTrace) {
      debugPrint('Failed to register push token: ${error.message}\n$stackTrace');
    }
  }

  void handleForegroundMessage(Map<String, dynamic> message) {
    final action = _mapMessageToAction(message);
    if (action == null) {
      return;
    }

    if (action.destination == _PushDestination.chat && action.chatId != null) {
      try {
        ref.read(chatControllerProvider.notifier).selectChat(action.chatId!);
      } catch (error, stackTrace) {
        debugPrint('Failed to update chat after foreground push: $error\n$stackTrace');
      }
    }
  }

  void handleMessageInteraction(Map<String, dynamic> message) {
    final action = _mapMessageToAction(message);
    if (action == null) {
      return;
    }

    switch (action.destination) {
      case _PushDestination.results:
        _openResults();
        break;
      case _PushDestination.chat:
        _openChat(action.chatId);
        break;
    }
  }

  _PushNotificationAction? _mapMessageToAction(Map<String, dynamic> message) {
    final data = _extractData(message);
    final type = (data['type'] ?? data['event'])?.toString().toLowerCase();
    final deeplink = data['deeplink']?.toString().toLowerCase();
    final chatId = data['chatId']?.toString() ?? data['chat_id']?.toString();

    if (deeplink != null) {
      final destination = _mapDeeplink(deeplink);
      if (destination != null) {
        return _PushNotificationAction(destination: destination, chatId: chatId);
      }
    }

    final notificationTitle = data['notification_title']?.toString().toLowerCase();
    final effectiveType = type ?? notificationTitle;

    if (effectiveType == null) {
      return null;
    }

    if (effectiveType.contains('report_ready') || effectiveType.contains('отчет готов')) {
      return const _PushNotificationAction(destination: _PushDestination.results);
    }
    if (effectiveType.contains('new_message') || effectiveType.contains('новое сообщение')) {
      return _PushNotificationAction(destination: _PushDestination.chat, chatId: chatId);
    }

    return null;
  }

  Map<String, dynamic> _extractData(Map<String, dynamic> message) {
    final normalized = <String, dynamic>{};

    void merge(Map<dynamic, dynamic>? source) {
      if (source == null) {
        return;
      }
      for (final entry in source.entries) {
        normalized[entry.key.toString()] = entry.value;
      }
    }

    merge(message);
    final data = message['data'];
    if (data is Map<dynamic, dynamic>) {
      merge(data);
    }
    final notification = message['notification'];
    if (notification is Map<dynamic, dynamic>) {
      merge(notification);
      if (notification['title'] != null) {
        normalized['notification_title'] = notification['title'];
      }
    }

    return normalized;
  }

  _PushDestination? _mapDeeplink(String deeplink) {
    final normalized = deeplink.trim();
    if (normalized.isEmpty) {
      return null;
    }

    if (normalized == ResultsPage.routePath ||
        normalized == ResultsPage.routeName ||
        normalized.contains('results')) {
      return _PushDestination.results;
    }

    if (normalized == ChatPage.routePath ||
        normalized == ChatPage.routeName ||
        normalized.contains('chat')) {
      return _PushDestination.chat;
    }

    return null;
  }

  void _openResults() {
    final router = ref.read(appRouterProvider);
    router.go(ResultsPage.routePath);
  }

  void _openChat(String? chatId) {
    final router = ref.read(appRouterProvider);
    router.go(ChatPage.routePath);
    if (chatId != null && chatId.isNotEmpty) {
      Future<void>.delayed(const Duration(milliseconds: 100), () {
        try {
          ref.read(chatControllerProvider.notifier).selectChat(chatId);
        } catch (error, stackTrace) {
          debugPrint('Failed to navigate to chat $chatId: $error\n$stackTrace');
        }
      });
    }
  }

  void _dispose() {}
}

enum _PushDestination { results, chat }

class _PushNotificationAction {
  const _PushNotificationAction({required this.destination, this.chatId});

  final _PushDestination destination;
  final String? chatId;
}
