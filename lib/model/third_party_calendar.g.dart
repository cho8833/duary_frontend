// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'third_party_calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppleCalendar _$AppleCalendarFromJson(Map<String, dynamic> json) =>
    AppleCalendar(
      json['id'] as String,
      json['name'] as String,
      CalendarOwner.fromJson(json['owner'] as String),
    );

Map<String, dynamic> _$AppleCalendarToJson(AppleCalendar instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'owner': instance.owner,
    };
