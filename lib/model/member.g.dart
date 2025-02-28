// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      json['name'] as String,
      Character.fromJson(json['character'] as String),
      MemberStatus.fromJson(json['status'] as String),
      (json['socialId'] as num).toInt(),
      json['provider'] as String,
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'name': instance.name,
      'character': instance.character,
      'status': instance.status,
      'socialId': instance.socialId,
      'provider': instance.provider,
    };
