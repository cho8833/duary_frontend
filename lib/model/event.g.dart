// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      json['id'] as String,
      DateTime.parse(json['startDateTime'] as String),
      DateTime.parse(json['endDateTime'] as String),
      json['title'] as String,
      (json['createdBy'] as num).toInt(),
      json['isTogether'] as bool,
      json['isAllDay'] as bool,
      json['coupleId'] as String,
      content: json['content'] as String?,
      location: json['location'] as String?,
      hangOutWith: json['hangOutWith'] as String?,
      recurrence: json['recurrence'] == null
          ? null
          : Recurrence.fromJson(json['recurrence'] as Map<String, dynamic>),
    )..member = Member.fromJson(json['member'] as Map<String, dynamic>);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
      'content': instance.content,
      'title': instance.title,
      'createdBy': instance.createdBy,
      'isTogether': instance.isTogether,
      'isAllDay': instance.isAllDay,
      'coupleId': instance.coupleId,
      'location': instance.location,
      'hangOutWith': instance.hangOutWith,
      'recurrence': instance.recurrence,
      'member': instance.member,
    };

Recurrence _$RecurrenceFromJson(Map<String, dynamic> json) => Recurrence(
      RepeatFrequency.fromJson(json['frequency'] as String),
      (json['interval'] as num).toInt(),
      DateTime.parse(json['repeatStartDate'] as String),
      DateTime.parse(json['repeatEndDate'] as String),
    );

Map<String, dynamic> _$RecurrenceToJson(Recurrence instance) =>
    <String, dynamic>{
      'frequency': instance.frequency,
      'interval': instance.interval,
      'repeatStartDate': instance.repeatStartDate.toIso8601String(),
      'repeatEndDate': instance.repeatEndDate.toIso8601String(),
    };
