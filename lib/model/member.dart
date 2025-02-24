import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  String name;
  String character;


  Member(this.name, this.character);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}