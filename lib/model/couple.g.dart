// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Couple _$CoupleFromJson(Map<String, dynamic> json) => Couple(
      DateTime.parse(json['relationDate'] as String),
      Member.fromJson(json['me'] as Map<String, dynamic>),
      Member.fromJson(json['lover'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CoupleToJson(Couple instance) => <String, dynamic>{
      'relationDate': instance.relationDate.toIso8601String(),
      'me': instance.me,
      'lover': instance.lover,
    };
