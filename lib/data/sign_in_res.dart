import 'package:duary/data/authorization_token_res.dart';
import 'package:duary/model/member.dart' show Member;
import 'package:json_annotation/json_annotation.dart';

part 'sign_in_res.g.dart';

@JsonSerializable(createToJson: false)
final class SignInRes {
  Member member;

  AuthorizationTokenRes token;

  bool isRegister;


  SignInRes(this.member, this.token, this.isRegister);

  factory SignInRes.fromJson(Object json) =>
      _$SignInResFromJson(json as Map<String, dynamic>);



}
