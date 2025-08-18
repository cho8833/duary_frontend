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


  Member(this.socialId, this.provider, { this.character, this.name, this.coupleId, this.birthday, List<AppleCalendar>? syncedAppleCalendar}) {
    this.syncedAppleCalendar = syncedAppleCalendar ?? [];
  }

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}

@JsonSerializable()
class AppleCalendar {
  String id;
  String name;

  AppleCalendar(this.id, this.name);

  Map<String, dynamic> toJson() => _$AppleCalendarToJson(this);

  factory AppleCalendar.fromJson(Map<String, dynamic> json) => _$AppleCalendarFromJson(json);
}