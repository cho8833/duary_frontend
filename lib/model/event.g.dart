// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      (json['id'] as num).toInt(),
      DateTime.parse(json['startDateTime'] as String),
      DateTime.parse(json['endDateTime'] as String),
      json['content'] as String,
      json['title'] as String,
      Member.fromJson(json['member'] as Map<String, dynamic>),
      json['isTogether'] as bool,
      (json['coupleId'] as num).toInt(),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
      'content': instance.content,
      'title': instance.title,
      'member': instance.member,
      'isTogether': instance.isTogether,
      'coupleId': instance.coupleId,
    };
