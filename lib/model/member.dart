import 'package:device_calendar/device_calendar.dart';
import 'package:duary/model/enums/alarm_offset.dart';
import 'package:duary/model/enums/character.dart';
import 'package:duary/support/iso8601_time_zone_formatter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  String? name;
  Character? character;
  String? coupleId;
  @ISO8601TimeZoneFormatter()
  DateTime? birthday;
  String socialId;
  String provider;
  List<AppleCalendar> syncedAppleCalendar = [];

  String getId() {
    return "$socialId-$provider";
  }

  Member(this.socialId, this.provider,
      {this.character,
      this.name,
      this.coupleId,
      this.birthday,
      List<AppleCalendar>? syncedAppleCalendar}) {
    this.syncedAppleCalendar = syncedAppleCalendar ?? [];
  }

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}

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

  Map<String, dynamic> toJson() => _$AppleCalendarToJson(this);

  factory AppleCalendar.fromJson(Map<String, dynamic> json) =>
      _$AppleCalendarFromJson(json);
}
