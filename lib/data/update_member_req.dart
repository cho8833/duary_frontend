import 'package:duary/model/enums/character.dart';
import 'package:duary/support/iso8601_time_zone_formatter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_member_req.g.dart';

@JsonSerializable(createFactory: false)
class UpdateMemberReq {
  String? name;

  @ISO8601TimeZoneFormatter()
  DateTime? birthday;

  Character? character;

  UpdateMemberReq(this.name, this.birthday, this.character);

  Map<String, dynamic> toJson() => _$UpdateMemberReqToJson(this);
}