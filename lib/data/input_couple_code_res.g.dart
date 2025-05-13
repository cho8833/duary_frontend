// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_couple_code_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputCoupleCodeRes _$InputCoupleCodeResFromJson(Map<String, dynamic> json) =>
    InputCoupleCodeRes(
      AuthorizationTokenRes.fromJson(json['token'] as Object),
      Member.fromJson(json['member'] as Map<String, dynamic>),
      Couple.fromJson(json['couple'] as Map<String, dynamic>),
    );
