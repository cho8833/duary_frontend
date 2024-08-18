import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  int id;
  String username;
  int colorCode;
  String character;

  Member(this.id, this.username, this.colorCode, this.character);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}