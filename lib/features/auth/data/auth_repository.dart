import 'dart:async';
import 'dart:math';

import '../domain/auth_tokens.dart';
import 'auth_types.dart';

class AuthRepository {
  AuthRepository({Duration latency = const Duration(milliseconds: 600)}) : _latency = latency;

  final Duration _latency;
  final _random = Random();
  final Map<String, _MockUser> _usersByEmail = {};
  final Map<String, _MockUser> _usersByRefresh = {};
  final Map<String, _OtpSession> _otpByPhone = {};

  Future<AuthTokens> loginWithEmail({required String email, required String password}) async {
    await Future<void>.delayed(_latency);
    final user = _usersByEmail[email.toLowerCase()];
    if (user == null || user.password != password) {
      throw const AuthException('Неверный email или пароль');
    }
    return _issueTokens(user);
  }

  Future<AuthTokens> registerWithEmail({required String email, required String password}) async {
    await Future<void>.delayed(_latency);
    final normalizedEmail = email.toLowerCase();
    if (_usersByEmail.containsKey(normalizedEmail)) {
      throw const AuthException('Пользователь с таким email уже существует');
    }
    final user = _MockUser(id: _generateId(), email: normalizedEmail, password: password);
    _usersByEmail[normalizedEmail] = user;
    return _issueTokens(user);
  }

  Future<String> requestPhoneOtp(String phoneNumber) async {
    await Future<void>.delayed(_latency);
    final code = (_random.nextInt(900000) + 100000).toString();
    _otpByPhone[phoneNumber] = _OtpSession(code: code, expiresAt: DateTime.now().add(const Duration(minutes: 5)));
    return code;
  }

  Future<AuthTokens> verifyPhoneOtp({required String phoneNumber, required String code}) async {
    await Future<void>.delayed(_latency);
    final session = _otpByPhone[phoneNumber];
    if (session == null || session.expiresAt.isBefore(DateTime.now())) {
      throw const AuthException('Код подтверждения истёк, запросите новый');
    }
    if (session.code != code) {
      throw const AuthException('Неверный код подтверждения');
    }
    _otpByPhone.remove(phoneNumber);
    final user = _usersByEmail.values.firstWhere(
      (user) => user.phoneNumber == phoneNumber,
      orElse: () {
        final newUser = _MockUser(id: _generateId(), phoneNumber: phoneNumber);
        _usersByEmail['phone_$phoneNumber'] = newUser;
        return newUser;
      },
    );
    return _issueTokens(user);
  }

  Future<AuthTokens> signInWithProvider(SocialProvider provider) async {
    await Future<void>.delayed(_latency);
    final user = _MockUser(id: _generateId(), oauthProvider: provider.name);
    return _issueTokens(user);
  }

  Future<AuthTokens> refreshTokens(String refreshToken) async {
    await Future<void>.delayed(_latency);
    final user = _usersByRefresh[refreshToken];
    if (user == null) {
      throw const AuthException('Сессия истекла, выполните вход заново');
    }
    return _issueTokens(user);
  }

  AuthTokens _issueTokens(_MockUser user) {
    final accessToken = 'access_${user.id}_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(999999)}';
    final refreshToken = 'refresh_${user.id}_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(999999)}';
    _usersByRefresh[refreshToken] = user;
    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  String _generateId() => (_random.nextInt(900000) + 100000).toString();
}

class _MockUser {
  _MockUser({required this.id, this.email, this.password, this.phoneNumber, this.oauthProvider});

  final String id;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? oauthProvider;
}

class _OtpSession {
  _OtpSession({required this.code, required this.expiresAt});

  final String code;
  final DateTime expiresAt;
}
