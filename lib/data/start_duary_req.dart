import 'package:duary/model/enums/character.dart';
import 'package:duary/support/iso8601_time_zone_formatter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'start_duary_req.g.dart';

@JsonSerializable(createFactory: false)
class StartDuaryReq {
  String name;
  @ISO8601TimeZoneFormatter()
  DateTime? birthday;
  @ISO8601TimeZoneFormatter()
  DateTime relationDate;
  Character myCharacter;

  StartDuaryReq(this.name, this.birthday, this.relationDate, this.myCharacter);

  Map<String, dynamic> toJson() => _$StartDuaryReqToJson(this);
}
