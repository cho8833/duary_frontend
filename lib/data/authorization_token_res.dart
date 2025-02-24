import 'package:duary/model/member.dart';
import 'package:json_annotation/json_annotation.dart';

part 'authorization_token_res.g.dart';

@JsonSerializable(createToJson: false)
final class AuthorizationTokenRes {
  Token token;
  Member member;
  bool isRegister;


  AuthorizationTokenRes(this.token, this.member, this.isRegister);

  factory AuthorizationTokenRes.fromJson(Object json) =>
      _$AuthorizationTokenResFromJson(json as Map<String, dynamic>);
}

@JsonSerializable(createToJson: false)
final class Token {
  String accessToken;
  String refreshToken;
  int refreshTokenExpireAt;
  int expireTime;

  Token(this.accessToken, this.refreshToken, this.refreshTokenExpireAt,
      this.expireTime);

  factory Token.fromJson(Object json) => _$TokenFromJson(json as Map<String, dynamic>);
  
  
}