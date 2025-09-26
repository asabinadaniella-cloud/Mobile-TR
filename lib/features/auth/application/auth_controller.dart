import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../data/auth_repository.dart';
import '../data/auth_types.dart';
import '../domain/auth_tokens.dart';
import 'auth_tokens_controller.dart';

class AuthState {
  const AuthState({
    this.status = const AsyncData<void>(null),
    this.lastSentOtp,
    this.lastPhoneNumber,
  });

  final AsyncValue<void> status;
  final String? lastSentOtp;
  final String? lastPhoneNumber;

  bool get isLoading => status.isLoading;

  AuthState copyWith({
    AsyncValue<void>? status,
    String? lastSentOtp,
    String? lastPhoneNumber,
  }) {
    return AuthState(
      status: status ?? this.status,
      lastSentOtp: lastSentOtp ?? this.lastSentOtp,
      lastPhoneNumber: lastPhoneNumber ?? this.lastPhoneNumber,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this.ref, this._repository) : super(const AuthState());

  final Ref ref;
  final AuthRepository _repository;

  Future<void> loginWithEmail(String email, String password) async {
    await _handleAuthFlow(
      method: 'email_login',
      action: () => _repository.loginWithEmail(email: email, password: password),
    );
  }

  Future<void> registerWithEmail(String email, String password) async {
    await _handleAuthFlow(
      method: 'email_register',
      action: () => _repository.registerWithEmail(email: email, password: password),
    );
  }

  Future<void> requestPhoneOtp(String phoneNumber) async {
    state = state.copyWith(status: const AsyncLoading<void>());
    try {
      final code = await _repository.requestPhoneOtp(phoneNumber);
      state = state.copyWith(
        status: const AsyncData<void>(null),
        lastSentOtp: code,
        lastPhoneNumber: phoneNumber,
      );
      await _logEvent('auth_otp_sent', 'phone');
    } on AuthException catch (error, stackTrace) {
      state = state.copyWith(status: AsyncError<void>(error.message, stackTrace));
      await _logEvent('auth_otp_failure', 'phone', error: error.message);
    } catch (error, stackTrace) {
      state = state.copyWith(status: AsyncError<void>(error, stackTrace));
      await _logEvent('auth_otp_failure', 'phone', error: error.toString());
    }
  }

  Future<void> verifyPhoneOtp({required String phoneNumber, required String code}) async {
    await _handleAuthFlow(
      method: 'phone_otp',
      action: () => _repository.verifyPhoneOtp(phoneNumber: phoneNumber, code: code),
    );
  }

  Future<void> signInWithProvider(SocialProvider provider) async {
    await _handleAuthFlow(
      method: 'oauth_${provider.name}',
      action: () => _repository.signInWithProvider(provider),
    );
  }

  Future<void> refreshTokens(String refreshToken) async {
    state = state.copyWith(status: const AsyncLoading<void>());
    try {
      final tokens = await _repository.refreshTokens(refreshToken);
      await _saveTokens(tokens);
      state = state.copyWith(status: const AsyncData<void>(null));
    } on AuthException catch (error, stackTrace) {
      state = state.copyWith(status: AsyncError<void>(error.message, stackTrace));
      await _logEvent('auth_failure', 'token_refresh', error: error.message);
    } catch (error, stackTrace) {
      state = state.copyWith(status: AsyncError<void>(error, stackTrace));
      await _logEvent('auth_failure', 'token_refresh', error: error.toString());
    }
  }

  Future<void> _handleAuthFlow({
    required String method,
    required Future<AuthTokens> Function() action,
  }) async {
    state = state.copyWith(status: const AsyncLoading<void>());
    await _logEvent('auth_start', method);
    try {
      final tokens = await action();
      await _saveTokens(tokens);
      state = state.copyWith(status: const AsyncData<void>(null));
      await _logEvent('auth_success', method);
    } on AuthException catch (error, stackTrace) {
      state = state.copyWith(status: AsyncError<void>(error.message, stackTrace));
      await _logEvent('auth_failure', method, error: error.message);
    } catch (error, stackTrace) {
      state = state.copyWith(status: AsyncError<void>(error, stackTrace));
      await _logEvent('auth_failure', method, error: error.toString());
    }
  }

  Future<void> _saveTokens(AuthTokens tokens) async {
    await ref.read(authTokensProvider.notifier).setTokens(
          accessToken: tokens.accessToken!,
          refreshToken: tokens.refreshToken!,
        );
  }

  Future<void> _logEvent(String name, String method, {String? error}) async {
    final analytics = ref.read(firebaseAnalyticsProvider);
    final parameters = <String, Object>{
      'method': method,
      if (error != null && error.isNotEmpty) 'error': error,
    };
    await analytics?.logEvent(name: name, parameters: parameters);
  }
}
