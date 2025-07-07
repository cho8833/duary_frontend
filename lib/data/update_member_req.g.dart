// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_member_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$UpdateMemberReqToJson(UpdateMemberReq instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birthday': _$JsonConverterToJson<String, DateTime>(
          instance.birthday, const ISO8601TimeZoneFormatter().toJson),
      'character': instance.character,
      'myAlarm': instance.myAlarm,
      'loverAlarm': instance.loverAlarm,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
