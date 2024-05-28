import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:duary/repository/secure_storage.dart';

class SecureStorageImpl implements SecureStorage {

  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = "accessToken";

  static const String _refreshTokenKey = "refreshToken";

  static const String themeKey = "theme";

  SecureStorageImpl(this._storage);

  @override
  Future<String?> getAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  @override
  Future<void> storeAccessToken(String value) {
    return _storage.write(key: _accessTokenKey, value: value);
  }

  @override
  Future<void> deleteAccessToken() {
    return _storage.delete(key: _accessTokenKey);
  }

  @override
  Future<int?> getThemeIndex() async {
    return  int.tryParse( await _storage.read(key: themeKey) ?? "");
  }

  @override
  Future<void> storeThemeIndex(int index) {
    return _storage.write(key: themeKey, value: index.toString());
  }

  @override
  Future<void> storeRefreshToken(String token) {
    return _storage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<String?> getRefreshToken() {
    return _storage.read(key: _refreshTokenKey);
  }

  @override
  Future<bool?> getThemeMode() {
    // TODO: implement getThemeMode
    throw UnimplementedError();
  }

  @override
  Future<void> storeThemeMode(bool isLight) {
    // TODO: implement storeThemeMode
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRefreshToken() {
    return _storage.delete(key: _refreshTokenKey);
  }
}