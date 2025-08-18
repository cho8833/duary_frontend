import 'package:duary/model/enums/alarm_offset.dart';
import 'package:duary/model/enums/character.dart';
import 'package:duary/model/member.dart';
import 'package:duary/support/iso8601_time_zone_formatter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_member_req.g.dart';

@JsonSerializable(createFactory: false)
class UpdateMemberReq {
  String? name;

  @ISO8601TimeZoneFormatter()
  DateTime? birthday;

  Character? character;

  AlarmOffset? myAlarm;

  AlarmOffset? loverAlarm;

  List<AppleCalendar>? syncedAppleCalendar;

  UpdateMemberReq(this.name, this.birthday, this.character, this.myAlarm, this.loverAlarm, this.syncedAppleCalendar);

  Map<String, dynamic> toJson() => _$UpdateMemberReqToJson(this);
}