import 'package:duary/repository/secure_storage.dart';

class TokenProvider {
  late final SecureStorage secureStorage;

  // singleton
  static final TokenProvider _instance = TokenProvider._internal();
  factory TokenProvider() => _instance;
  TokenProvider._internal();

  String? _accessToken;

  String? _refreshToken;

  Future<String?> get accessToken async {
    if (_accessToken == null) {
      return await secureStorage.getAccessToken();
    }
    return _accessToken;
  }

  Future<String?> get refreshToken async {
    if (_refreshToken == null) {
      return await secureStorage.getRefreshToken();
    }
    return _refreshToken;
  }

  storeAccessToken(String accessToken) async {
    _accessToken = accessToken;
    await secureStorage.storeAccessToken(accessToken);
  }

  storeRefreshToken(String refreshToken) async {
    _refreshToken = refreshToken;
    await secureStorage.storeRefreshToken(refreshToken);
  }

  storeAccessTokenInMemory(String accessToken) {
    _accessToken = accessToken;
  }

  deleteAccessTokenInMemory() {
    _accessToken = null;
  }

  deleteToken() {
    _accessToken = null;
    _refreshToken = null;
    secureStorage.deleteAccessToken();
    secureStorage.deleteRefreshToken();
  }
}