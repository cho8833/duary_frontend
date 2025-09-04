import 'package:duary/model/member.dart';
import 'package:duary/support/iso8601_time_zone_formatter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'couple.g.dart';

@JsonSerializable()
class Couple {
  @ISO8601TimeZoneFormatter()
  DateTime? relationDate;

  List<Member> members;

  String id;

  String code;

  Couple(this.id, this.relationDate, this.members, this.code);

  factory Couple.fromJson(Map<String, dynamic> json) => _$CoupleFromJson(json);

}