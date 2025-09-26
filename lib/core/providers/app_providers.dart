import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../database/app_database.dart';
import '../network/interceptors/jwt_interceptor.dart';
import '../storage/secure_token_storage.dart';
import '../../features/auth/application/auth_tokens_controller.dart';
import '../../features/auth/domain/auth_tokens.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final textScaleFactorProvider = StateProvider<double>((ref) => 1.0);

final localeProvider = StateProvider<Locale>((ref) => const Locale('ru'));

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  dio.interceptors.add(JwtInterceptor(ref));
  return dio;
});

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  final secureStorage = ref.watch(flutterSecureStorageProvider);
  return SecureTokenStorage(secureStorage);
});

final authTokensProvider = StateNotifierProvider<AuthTokensNotifier, AuthTokens>((ref) {
  final storage = ref.watch(secureTokenStorageProvider);
  return AuthTokensNotifier(storage);
});

final firebaseAnalyticsProvider = Provider<FirebaseAnalytics?>((ref) {
  return FirebaseAnalytics.instance;
});

final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});
