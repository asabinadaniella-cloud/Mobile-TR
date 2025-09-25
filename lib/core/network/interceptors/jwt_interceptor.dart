import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';

class JwtInterceptor extends Interceptor {
  JwtInterceptor(this.ref);

  final Ref ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = ref.read(authTokenProvider);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        final requestOptions = err.requestOptions;
        final dio = ref.read(dioProvider);
        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      }
    }
    super.onError(err, handler);
  }

  Future<bool> _refreshToken() async {
    final refreshToken = ref.read(refreshTokenProvider);
    if (refreshToken == null) {
      return false;
    }
    // TODO: Implement refresh flow using Dio once backend is available.
    return false;
  }
}
