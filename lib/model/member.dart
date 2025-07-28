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

  AlarmOffset myAlarm;
  AlarmOffset loverAlarm;

  String getId() {
    return "$socialId-$provider";
  }


  Member(this.name, this.character, this.coupleId, this.birthday, this.socialId,
      this.provider, this.myAlarm, this.loverAlarm);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}