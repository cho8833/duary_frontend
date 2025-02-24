// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorization_token_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorizationTokenRes _$AuthorizationTokenResFromJson(
        Map<String, dynamic> json) =>
    AuthorizationTokenRes(
      Token.fromJson(json['token'] as Object),
      Member.fromJson(json['member'] as Map<String, dynamic>),
      json['isRegister'] as bool,
    );

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      json['accessToken'] as String,
      json['refreshToken'] as String,
      (json['refreshTokenExpireAt'] as num).toInt(),
      (json['expireTime'] as num).toInt(),
    );
