// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorization_token_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorizationTokenRes _$AuthorizationTokenResFromJson(
        Map<String, dynamic> json) =>
    AuthorizationTokenRes(
      json['accessToken'] as String,
      json['refreshToken'] as String,
      (json['refreshTokenExpireAt'] as num).toInt(),
      (json['expireTime'] as num).toInt(),
    );
