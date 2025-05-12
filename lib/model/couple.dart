import 'package:duary/model/member.dart';
import 'package:json_annotation/json_annotation.dart';

part 'couple.g.dart';

@JsonSerializable()
class Couple {
  DateTime relationDate;

  List<Member> members;

  String id;

  String code;

  Couple(this.id, this.relationDate, this.members, this.code);

  factory Couple.fromJson(Map<String, dynamic> json) => _$CoupleFromJson(json);

}