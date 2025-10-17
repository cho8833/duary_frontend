import 'dart:convert';

import 'package:duary/model/third_party_calendar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:duary/repository/local_storage.dart';

class SecureStorage implements LocalStorage {

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = "accessToken";

  static const String _refreshTokenKey = "refreshToken";

  static const String _appleCalendarKey = "appleCalendar";


  static final SecureStorage _instance = SecureStorage._internal();

  SecureStorage._internal();

  factory SecureStorage() {
    return _instance;
  }

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
  Future<void> storeRefreshToken(String token) {
    return _storage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<String?> getRefreshToken() {
    return _storage.read(key: _refreshTokenKey);
  }
  @override
  Future<void> deleteRefreshToken() {
    return _storage.delete(key: _refreshTokenKey);
  }

  @override
  Future<void> storeAppleCalendar(List<AppleCalendar> calendars) {
    return _storage.write(key: _appleCalendarKey, value: jsonEncode(calendars));
  }

  @override
  Future<List<AppleCalendar>> getAppleCalendar() async {
    String? read = await _storage.read(key: _appleCalendarKey);

    if (read == null) {
      return [];
    }

    List<dynamic> result = jsonDecode(read);

    if (result.isEmpty) {
      return [];
    } else {
      return result.map((r) => AppleCalendar.fromJson(r)).toList();
    }
  }
}