// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInRes _$SignInResFromJson(Map<String, dynamic> json) => SignInRes(
      Member.fromJson(json['member'] as Map<String, dynamic>),
      AuthorizationTokenRes.fromJson(json['token'] as Object),
      json['isRegister'] as bool,
    );
