// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      json['name'] as String,
      Character.fromJson(json['character'] as String),
      (json['socialId'] as num).toInt(),
      json['provider'] as String,
      json['coupleId'] as String?,
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'name': instance.name,
      'character': instance.character,
      'coupleId': instance.coupleId,
      'socialId': instance.socialId,
      'provider': instance.provider,
    };
