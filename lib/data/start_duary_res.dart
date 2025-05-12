import 'package:duary/data/authorization_token_res.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/model/member.dart' show Member;
import 'package:json_annotation/json_annotation.dart';

part 'start_duary_res.g.dart';

@JsonSerializable(createToJson: false)
final class StartDuaryRes {
  Member member;

  Couple couple;

  AuthorizationTokenRes token;

  StartDuaryRes(this.member, this.couple, this.token);

  factory StartDuaryRes.fromJson(Object json) =>
      _$StartDuaryResFromJson(json as Map<String, dynamic>);
}