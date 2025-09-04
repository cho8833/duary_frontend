// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_duary_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$StartDuaryReqToJson(StartDuaryReq instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birthday': _$JsonConverterToJson<String, DateTime>(
          instance.birthday, const ISO8601TimeZoneFormatter().toJson),
      'relationDate': _$JsonConverterToJson<String, DateTime>(
          instance.relationDate, const ISO8601TimeZoneFormatter().toJson),
      'myCharacter': instance.myCharacter,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
