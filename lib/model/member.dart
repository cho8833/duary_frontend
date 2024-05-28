import 'package:json_annotation/json_annotation.dart';
import 'package:duary/model/enums/role.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  int id;
  String username;
  Role role;

  Member(this.id, this.username, this.role);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}