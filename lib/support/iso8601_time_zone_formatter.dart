import 'package:json_annotation/json_annotation.dart';

class ISO8601TimeZoneFormatter implements JsonConverter<DateTime, String> {

  const ISO8601TimeZoneFormatter();

  @override
  DateTime fromJson(String json) {
    throw UnimplementedError();
  }

  @override
  String toJson(DateTime object) {
    String timeString = object.toIso8601String();
    if (object.isUtc) {
      return timeString;
    } else {
      if (object.timeZoneOffset.inHours >= 0) {
        return '$timeString+${object.timeZoneOffset.inHours.toString().padLeft(2, "0")}:00';
      } else {
        return '$timeString-${object.timeZoneOffset.inHours.toString().padLeft(2, "0")}:00';
      }
    }
  }

}