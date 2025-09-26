import 'package:riverpod/riverpod.dart';

import '../../../core/storage/secure_token_storage.dart';
import '../domain/auth_tokens.dart';

class AuthTokensNotifier extends StateNotifier<AuthTokens> {
  AuthTokensNotifier(this._storage) : super(AuthTokens.empty) {
    _restore();
  }

  final SecureTokenStorage _storage;

  Future<void> _restore() async {
    final stored = await _storage.readTokens();
    state = AuthTokens(
      accessToken: stored.accessToken,
      refreshToken: stored.refreshToken,
    );
  }

  Future<void> setTokens({required String accessToken, required String refreshToken}) async {
    state = AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
    await _storage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> updateAccessToken(String accessToken) async {
    state = state.copyWith(accessToken: accessToken);
    await _storage.saveAccessToken(accessToken);
  }

  Future<void> clear() async {
    state = AuthTokens.empty;
    await _storage.clear();
  }
}
