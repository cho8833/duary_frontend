import 'package:duary/data/authorization_token_res.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:duary/model/member.dart' show Member;
import 'package:duary/model/couple.dart';

part 'input_couple_code_res.g.dart';

@JsonSerializable(createToJson: false)
final class InputCoupleCodeRes{
  AuthorizationTokenRes token;

  Member member;

  Couple couple;

  InputCoupleCodeRes(this.token, this.member ,this.couple);

  factory InputCoupleCodeRes.fromJson(Object json) =>
      _$InputCoupleCodeResFromJson(json as Map<String, dynamic>);

}

