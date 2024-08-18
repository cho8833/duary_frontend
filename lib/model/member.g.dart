// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      (json['id'] as num).toInt(),
      json['username'] as String,
      (json['colorCode'] as num).toInt(),
      json['character'] as String,
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'colorCode': instance.colorCode,
      'character': instance.character,
    };
