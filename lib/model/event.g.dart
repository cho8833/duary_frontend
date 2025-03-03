// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      (json['id'] as num).toInt(),
      DateTime.parse(json['startDateTime'] as String),
      DateTime.parse(json['endDateTime'] as String),
      json['title'] as String,
      Member.fromJson(json['member'] as Map<String, dynamic>),
      json['isTogether'] as bool,
      (json['coupleId'] as num).toInt(),
      json['isAllDay'] as bool,
      location: json['location'] as String?,
      meetWith: json['meetWith'] as String?,
      content: json['content'] as String?,
      repeat: json['repeat'] == null
          ? null
          : Repeat.fromJson(json['repeat'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
      'content': instance.content,
      'title': instance.title,
      'member': instance.member,
      'isTogether': instance.isTogether,
      'isAllDay': instance.isAllDay,
      'coupleId': instance.coupleId,
      'location': instance.location,
      'meetWith': instance.meetWith,
      'repeat': instance.repeat,
    };

Repeat _$RepeatFromJson(Map<String, dynamic> json) => Repeat(
      RepeatFrequency.fromJson(json['frequency'] as String),
    );

Map<String, dynamic> _$RepeatToJson(Repeat instance) => <String, dynamic>{
      'frequency': instance.frequency,
    };
