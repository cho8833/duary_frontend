import 'package:duary/data/authorization_token_res.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/model/member.dart' show Member;
import 'package:json_annotation/json_annotation.dart';

part 'duary_info_res.g.dart';

@JsonSerializable(createToJson: false)
final class DuaryInfoRes {
  Member member;

  Couple couple;

  AuthorizationTokenRes token;

  DuaryInfoRes(this.member, this.couple, this.token);

  factory DuaryInfoRes.fromJson(Object json) =>
      _$DuaryInfoResFromJson(json as Map<String, dynamic>);
}