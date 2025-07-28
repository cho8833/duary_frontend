import 'package:duary/support/iso8601_time_zone_formatter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_couple_req.g.dart';

@JsonSerializable(createFactory: false)
final class UpdateCoupleReq {
  @ISO8601TimeZoneFormatter()
  DateTime relationDate;

  UpdateCoupleReq(this.relationDate);

  Map<String, dynamic> toJson() => _$UpdateCoupleReqToJson(this);
}