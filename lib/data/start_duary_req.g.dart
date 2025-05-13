// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_duary_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartDuaryReq _$StartDuaryReqFromJson(Map<String, dynamic> json) =>
    StartDuaryReq(
      json['name'] as String,
      const ISO8601TimeZoneFormatter().fromJson(json['birthday'] as String),
      const ISO8601TimeZoneFormatter().fromJson(json['relationDate'] as String),
      Character.fromJson(json['myCharacter'] as String),
    );

Map<String, dynamic> _$StartDuaryReqToJson(StartDuaryReq instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birthday': const ISO8601TimeZoneFormatter().toJson(instance.birthday),
      'relationDate':
          const ISO8601TimeZoneFormatter().toJson(instance.relationDate),
      'myCharacter': instance.myCharacter,
    };
