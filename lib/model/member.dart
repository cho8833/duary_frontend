import 'package:duary/model/enums/character.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  String name;
  Character character;
  String? coupleId;
  int socialId;
  String provider;


  Member(this.name, this.character, this.socialId, this.provider, this.coupleId);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}