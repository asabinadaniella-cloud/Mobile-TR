import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../network/interceptors/jwt_interceptor.dart';

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

final authTokenProvider = StateProvider<String?>((ref) => null);
final refreshTokenProvider = StateProvider<String?>((ref) => null);
