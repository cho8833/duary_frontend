// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duary_info_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DuaryInfoRes _$DuaryInfoResFromJson(Map<String, dynamic> json) => DuaryInfoRes(
      Member.fromJson(json['member'] as Map<String, dynamic>),
      json['couple'] == null
          ? null
          : Couple.fromJson(json['couple'] as Map<String, dynamic>),
      AuthorizationTokenRes.fromJson(json['token'] as Object),
    );
