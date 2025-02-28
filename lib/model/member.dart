import 'package:duary/model/enums/character.dart';
import 'package:duary/model/enums/member_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  String name;
  Character character;
  MemberStatus status;
  int socialId;
  String provider;


  Member(this.name, this.character, this.status, this.socialId, this.provider);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}