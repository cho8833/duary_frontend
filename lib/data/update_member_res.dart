import 'package:duary/model/couple.dart';
import 'package:duary/model/member.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_member_res.g.dart';

@JsonSerializable(createToJson: false)
final class UpdateMemberRes{
  Member member;

  Couple couple;

  UpdateMemberRes(this.member, this.couple);

  factory UpdateMemberRes.fromJson(Object json) =>
      _$UpdateMemberResFromJson(json as Map<String, dynamic>);

}