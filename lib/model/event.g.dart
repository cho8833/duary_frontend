// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      json['id'] as String,
      json['coupleId'] as String,
      json['createdBy'] as String,
      const ISO8601TimeZoneFormatter()
          .fromJson(json['startDateTime'] as String),
      const ISO8601TimeZoneFormatter().fromJson(json['endDateTime'] as String),
      json['title'] as String,
      Frequency.fromJson(json['frequency'] as String),
      json['isTogether'] as bool,
      json['isAllDay'] as bool,
      recurStartDate: _$JsonConverterFromJson<String, DateTime>(
          json['recurStartDate'], const ISO8601TimeZoneFormatter().fromJson),
      recurEndDate: _$JsonConverterFromJson<String, DateTime>(
          json['recurEndDate'], const ISO8601TimeZoneFormatter().fromJson),
      daily: json['daily'] == null
          ? null
          : DailyRecurrence.fromJson(json['daily'] as Map<String, dynamic>),
      weekly: json['weekly'] == null
          ? null
          : WeeklyRecurrence.fromJson(json['weekly'] as Map<String, dynamic>),
      monthly: json['monthly'] == null
          ? null
          : MonthlyRecurrence.fromJson(json['monthly'] as Map<String, dynamic>),
      yearly: json['yearly'] == null
          ? null
          : YearlyRecurrence.fromJson(json['yearly'] as Map<String, dynamic>),
      content: json['content'] as String?,
      location: json['location'] as String?,
      hangOutWith: json['hangOutWith'] as String?,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'coupleId': instance.coupleId,
      'createdBy': instance.createdBy,
      'startDateTime':
          const ISO8601TimeZoneFormatter().toJson(instance.startDateTime),
      'endDateTime':
          const ISO8601TimeZoneFormatter().toJson(instance.endDateTime),
      'frequency': instance.frequency,
      'recurStartDate': _$JsonConverterToJson<String, DateTime>(
          instance.recurStartDate, const ISO8601TimeZoneFormatter().toJson),
      'recurEndDate': _$JsonConverterToJson<String, DateTime>(
          instance.recurEndDate, const ISO8601TimeZoneFormatter().toJson),
      'daily': instance.daily,
      'weekly': instance.weekly,
      'monthly': instance.monthly,
      'yearly': instance.yearly,
      'title': instance.title,
      'content': instance.content,
      'location': instance.location,
      'hangOutWith': instance.hangOutWith,
      'isTogether': instance.isTogether,
      'isAllDay': instance.isAllDay,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

DailyRecurrence _$DailyRecurrenceFromJson(Map<String, dynamic> json) =>
    DailyRecurrence(
      (json['interval'] as num).toInt(),
    );

Map<String, dynamic> _$DailyRecurrenceToJson(DailyRecurrence instance) =>
    <String, dynamic>{
      'interval': instance.interval,
    };

WeeklyRecurrence _$WeeklyRecurrenceFromJson(Map<String, dynamic> json) =>
    WeeklyRecurrence(
      (json['weekdays'] as List<dynamic>)
          .map((e) => Weekday.fromJson(e as String))
          .toList(),
    );

Map<String, dynamic> _$WeeklyRecurrenceToJson(WeeklyRecurrence instance) =>
    <String, dynamic>{
      'weekdays': instance.weekdays,
    };

MonthlyRecurrence _$MonthlyRecurrenceFromJson(Map<String, dynamic> json) =>
    MonthlyRecurrence(
      (json['days'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );

Map<String, dynamic> _$MonthlyRecurrenceToJson(MonthlyRecurrence instance) =>
    <String, dynamic>{
      'days': instance.days,
    };

YearlyRecurrence _$YearlyRecurrenceFromJson(Map<String, dynamic> json) =>
    YearlyRecurrence(
      (json['month'] as num).toInt(),
      (json['day'] as num).toInt(),
    );

Map<String, dynamic> _$YearlyRecurrenceToJson(YearlyRecurrence instance) =>
    <String, dynamic>{
      'month': instance.month,
      'day': instance.day,
    };
