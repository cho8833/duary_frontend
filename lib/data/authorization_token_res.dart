import 'package:json_annotation/json_annotation.dart';

part 'authorization_token_res.g.dart';

@JsonSerializable(createToJson: false)
final class AuthorizationTokenRes {
  String accessToken;
  String refreshToken;
  int id;

  AuthorizationTokenRes(this.accessToken, this.refreshToken, this.id);

  factory AuthorizationTokenRes.fromJson(Object json) =>
      _$AuthorizationTokenResFromJson(json as Map<String, dynamic>);
}