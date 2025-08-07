// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      json['socialId'] as String,
      json['provider'] as String,
      character: json['character'] == null
          ? null
          : Character.fromJson(json['character'] as String),
      name: json['name'] as String?,
      coupleId: json['coupleId'] as String?,
      birthday: _$JsonConverterFromJson<String, DateTime>(
          json['birthday'], const ISO8601TimeZoneFormatter().fromJson),
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'name': instance.name,
      'character': instance.character,
      'coupleId': instance.coupleId,
      'birthday': _$JsonConverterToJson<String, DateTime>(
          instance.birthday, const ISO8601TimeZoneFormatter().toJson),
      'socialId': instance.socialId,
      'provider': instance.provider,
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
