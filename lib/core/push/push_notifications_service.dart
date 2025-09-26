import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../../features/chat/application/chat_controller.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/results/presentation/pages/results_page.dart';

final pushNotificationsServiceProvider = Provider<PushNotificationsService>((ref) {
  final messaging = ref.watch(firebaseMessagingProvider);
  final dio = ref.watch(dioProvider);
  return PushNotificationsService(ref, messaging, dio);
});

final pushNotificationsInitializerProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(pushNotificationsServiceProvider);
  await service.initialize();
});

class PushNotificationsService {
  PushNotificationsService(this.ref, this._messaging, this._dio);

  final Ref ref;
  final FirebaseMessaging _messaging;
  final Dio _dio;

  bool _initialized = false;
  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedSubscription;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('Push notifications permission denied');
      _initialized = true;
      return;
    }

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _registerCurrentToken();
    _tokenSubscription = _messaging.onTokenRefresh.listen(_registerToken);

    _messageSubscription = FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    _messageOpenedSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((message) => _handleMessage(message, fromInteraction: true));

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage, fromInteraction: true);
    }

    _initialized = true;
    ref.onDispose(_dispose);
  }

  Future<void> _registerCurrentToken() async {
    final token = await _messaging.getToken();
    if (token != null) {
      await _registerToken(token);
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      await _dio.post<dynamic>(
        '/push/register',
        data: <String, dynamic>{'token': token},
      );
    } on DioException catch (error, stackTrace) {
      debugPrint('Failed to register push token: ${error.message}\n$stackTrace');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final action = _mapMessageToAction(message);
    if (action == null) {
      return;
    }

    if (action.destination == _PushDestination.chat && action.chatId != null) {
      // Ensure chat data is up-to-date when a new message arrives.
      try {
        ref.read(chatControllerProvider.notifier).selectChat(action.chatId!);
      } catch (error, stackTrace) {
        debugPrint('Failed to update chat after foreground push: $error\n$stackTrace');
      }
    }
  }

  void _handleMessage(RemoteMessage message, {required bool fromInteraction}) {
    final action = _mapMessageToAction(message);
    if (action == null || !fromInteraction) {
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

  _PushNotificationAction? _mapMessageToAction(RemoteMessage message) {
    final data = message.data;
    final type = (data['type'] ?? data['event'] ?? message.notification?.title)?.toString().toLowerCase();
    final deeplink = data['deeplink']?.toString().toLowerCase();
    final chatId = data['chatId']?.toString() ?? data['chat_id']?.toString();

    if (deeplink != null) {
      final destination = _mapDeeplink(deeplink);
      if (destination != null) {
        return _PushNotificationAction(destination: destination, chatId: chatId);
      }
    }

    if (type == null) {
      return null;
    }

    if (type.contains('report_ready') || type.contains('отчет готов')) {
      return const _PushNotificationAction(destination: _PushDestination.results);
    }
    if (type.contains('new_message') || type.contains('новое сообщение')) {
      return _PushNotificationAction(destination: _PushDestination.chat, chatId: chatId);
    }

    return null;
  }

  _PushDestination? _mapDeeplink(String deeplink) {
    final normalized = deeplink.trim();
    if (normalized.isEmpty) {
      return null;
    }

    if (normalized == ResultsPage.routePath || normalized == ResultsPage.routeName || normalized.contains('results')) {
      return _PushDestination.results;
    }

    if (normalized == ChatPage.routePath || normalized == ChatPage.routeName || normalized.contains('chat')) {
      return _PushDestination.chat;
    }

    return null;
  }

  void _dispose() {
    _tokenSubscription?.cancel();
    _messageSubscription?.cancel();
    _messageOpenedSubscription?.cancel();
  }
}

enum _PushDestination { results, chat }

class _PushNotificationAction {
  const _PushNotificationAction({required this.destination, this.chatId});

  final _PushDestination destination;
  final String? chatId;
}
