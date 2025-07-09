// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_event_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$SaveEventReqToJson(SaveEventReq instance) =>
    <String, dynamic>{
      'startDateTime':
          const ISO8601TimeZoneFormatter().toJson(instance.startDateTime),
      'endDateTime':
          const ISO8601TimeZoneFormatter().toJson(instance.endDateTime),
      'recurStartDate': _$JsonConverterToJson<String, DateTime>(
          instance.recurStartDate, const ISO8601TimeZoneFormatter().toJson),
      'recurEndDate': _$JsonConverterToJson<String, DateTime>(
          instance.recurEndDate, const ISO8601TimeZoneFormatter().toJson),
      'frequency': instance.frequency,
      'daily': instance.daily,
      'weekly': instance.weekly,
      'monthly': instance.monthly,
      'yearly': instance.yearly,
      'title': instance.title,
      'content': instance.content,
      'location': instance.location,
      'hangOutWith': instance.hangOutWith,
      'isTogether': instance.isTogether,
      'isAllday': instance.isAllday,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
