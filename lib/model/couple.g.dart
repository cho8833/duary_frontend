// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Couple _$CoupleFromJson(Map<String, dynamic> json) => Couple(
      json['id'] as String,
      DateTime.parse(json['relationDate'] as String),
      (json['members'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..me = Member.fromJson(json['me'] as Map<String, dynamic>)
      ..lover = Member.fromJson(json['lover'] as Map<String, dynamic>);

Map<String, dynamic> _$CoupleToJson(Couple instance) => <String, dynamic>{
      'relationDate': instance.relationDate.toIso8601String(),
      'members': instance.members,
      'id': instance.id,
      'me': instance.me,
      'lover': instance.lover,
    };
