import 'package:json_annotation/json_annotation.dart';
import 'package:device_calendar/device_calendar.dart' show Calendar;

part 'third_party_calendar.g.dart';

enum CalendarOwner {
  my("MY", "내 일정"),
  lover("LOVER", "연인 일정"),
  together("TOGETHER", "공동 일정");

  final String json;

  final String title;

  const CalendarOwner(this.json, this.title);

  String toJson() {
    return json;
  }

  factory CalendarOwner.fromJson(String json) =>
      CalendarOwner.values.firstWhere((e) => e.json == json);
}

@JsonSerializable()
class AppleCalendar {
  String id;
  String name;
  CalendarOwner owner;

  AppleCalendar(this.id, this.name, this.owner);

  factory AppleCalendar.fromApple(Calendar calendar, CalendarOwner owner) {
    return AppleCalendar(calendar.id!, calendar.name!, owner);
  }

  factory AppleCalendar.fromJson(Map<String, dynamic> json) => _$AppleCalendarFromJson(json);

  Map<String, dynamic> toJson() => _$AppleCalendarToJson(this);
}