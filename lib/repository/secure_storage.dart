abstract class SecureStorage {
  Future<void> storeAccessToken(String value);
  Future<String?> getAccessToken();
  Future<void> deleteAccessToken();
  Future<int?> getThemeIndex();
  Future<void> storeThemeIndex(int index);
  Future<bool?> getThemeMode();
  Future<void> storeThemeMode(bool isLight);
  Future<String?> getRefreshToken();
  Future<void> storeRefreshToken(String token);
  Future<void> deleteRefreshToken();
}