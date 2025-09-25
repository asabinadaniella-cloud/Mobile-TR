class AuthTokens {
  const AuthTokens({this.accessToken, this.refreshToken});

  final String? accessToken;
  final String? refreshToken;

  bool get isAuthenticated =>
      accessToken != null && accessToken!.isNotEmpty && refreshToken != null && refreshToken!.isNotEmpty;

  AuthTokens copyWith({String? accessToken, String? refreshToken}) {
    return AuthTokens(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  static const empty = AuthTokens();
}
