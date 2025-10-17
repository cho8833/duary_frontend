import 'package:duary/model/third_party_calendar.dart';

abstract class LocalStorage {
  Future<void> storeAccessToken(String value);

  Future<String?> getAccessToken();

  Future<void> deleteAccessToken();

  Future<String?> getRefreshToken();

  Future<void> storeRefreshToken(String token);

  Future<void> deleteRefreshToken();

  Future<List<AppleCalendar>> getAppleCalendar();

  Future<void> storeAppleCalendar(List<AppleCalendar> calendars);
}