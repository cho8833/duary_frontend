// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Couple _$CoupleFromJson(Map<String, dynamic> json) => Couple(
      json['id'] as String,
      const ISO8601TimeZoneFormatter().fromJson(json['relationDate'] as String),
      (json['members'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['code'] as String,
    );

Map<String, dynamic> _$CoupleToJson(Couple instance) => <String, dynamic>{
      'relationDate':
          const ISO8601TimeZoneFormatter().toJson(instance.relationDate),
      'members': instance.members,
      'id': instance.id,
      'code': instance.code,
    };
