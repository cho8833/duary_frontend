// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Couple _$CoupleFromJson(Map<String, dynamic> json) => Couple(
      json['id'] as String,
      _$JsonConverterFromJson<String, DateTime>(
          json['relationDate'], const ISO8601TimeZoneFormatter().fromJson),
      (json['members'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['code'] as String,
    );

Map<String, dynamic> _$CoupleToJson(Couple instance) => <String, dynamic>{
      'relationDate': _$JsonConverterToJson<String, DateTime>(
          instance.relationDate, const ISO8601TimeZoneFormatter().toJson),
      'members': instance.members,
      'id': instance.id,
      'code': instance.code,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
