import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../../features/auth/application/auth_providers.dart';

class JwtInterceptor extends Interceptor {
  JwtInterceptor(this.ref);

  final Ref ref;
  Future<void>? _refreshFuture;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = ref.read(authTokensProvider).accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        await (_refreshFuture ??= _refreshToken());
        _refreshFuture = null;
        final requestOptions = err.requestOptions;
        final dio = ref.read(dioProvider);
        final token = ref.read(authTokensProvider).accessToken;
        if (token != null) {
          requestOptions.headers['Authorization'] = 'Bearer $token';
        }
        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } catch (_) {
        _refreshFuture = null;
      }
    }
    super.onError(err, handler);
  }

  Future<void> _refreshToken() async {
    final refreshToken = ref.read(authTokensProvider).refreshToken;
    if (refreshToken == null) {
      throw DioException(requestOptions: RequestOptions(path: ''), error: 'Refresh token missing');
    }
    final repository = ref.read(authRepositoryProvider);
    final tokens = await repository.refreshTokens(refreshToken);
    await ref.read(authTokensProvider.notifier).setTokens(
          accessToken: tokens.accessToken!,
          refreshToken: tokens.refreshToken!,
        );
  }
}
