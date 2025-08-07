import 'package:duary/model/enums/frequency.dart';
import 'package:duary/model/enums/weekday.dart';
import 'package:duary/model/member.dart';
import 'package:duary/support/iso8601_time_zone_formatter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable(createToJson: false)
class Event {
  String id;
  String coupleId;
  String createdBy;

  @ISO8601TimeZoneFormatter()
  DateTime startDateTime;
  @ISO8601TimeZoneFormatter()
  DateTime endDateTime;
  Frequency frequency;
  @ISO8601TimeZoneFormatter()
  DateTime? recurStartDate;
  @ISO8601TimeZoneFormatter()
  DateTime? recurEndDate;
  DailyRecurrence? daily;
  WeeklyRecurrence? weekly;
  MonthlyRecurrence? monthly;
  YearlyRecurrence? yearly;
  int? recurCount;

  String title;
  String? content;
  String? location;
  String? hangOutWith;
  bool isTogether;
  bool isAllDay;

  EventType eventType;

  @JsonKey(includeToJson: false, includeFromJson: false)
  late Member member;

  Event(
    this.id,
    this.coupleId,
    this.createdBy,
    this.startDateTime,
    this.endDateTime,
    this.title,
    this.frequency,
    this.isTogether,
    this.isAllDay,
    this.eventType, {
    this.recurStartDate,
    this.recurEndDate,
    this.daily,
    this.weekly,
    this.monthly,
    this.yearly,
    this.content,
    this.location,
    this.hangOutWith,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

class Recurrence {}

@JsonSerializable()
class DailyRecurrence extends Recurrence {
  int interval;

  DailyRecurrence(this.interval);

  Map<String, dynamic> toJson() => _$DailyRecurrenceToJson(this);

  factory DailyRecurrence.fromJson(Map<String, dynamic> json) =>
      _$DailyRecurrenceFromJson(json);
}

@JsonSerializable()
class WeeklyRecurrence extends Recurrence {
  List<Weekday> weekdays;

  WeeklyRecurrence(this.weekdays);

  Map<String, dynamic> toJson() => _$WeeklyRecurrenceToJson(this);

  factory WeeklyRecurrence.fromJson(Map<String, dynamic> json) =>
      _$WeeklyRecurrenceFromJson(json);
}

@JsonSerializable()
class MonthlyRecurrence extends Recurrence {
  List<int> days;

  MonthlyRecurrence(this.days);

  Map<String, dynamic> toJson() => _$MonthlyRecurrenceToJson(this);

  factory MonthlyRecurrence.fromJson(Map<String, dynamic> json) =>
      _$MonthlyRecurrenceFromJson(json);
}

@JsonSerializable()
class YearlyRecurrence extends Recurrence {
  int month;

  int day;

  YearlyRecurrence(this.month, this.day);

  Map<String, dynamic> toJson() => _$YearlyRecurrenceToJson(this);

  factory YearlyRecurrence.fromJson(Map<String, dynamic> json) =>
      _$YearlyRecurrenceFromJson(json);
}

enum EventType {
  normal("NORMAL"),
  birthday("BIRTHDAY"),
  anniversary("ANNIVERSARY");

  final String value;

  const EventType(this.value);

  factory EventType.fromJson(String json) =>
      EventType.values.firstWhere((t) => t.value == json);
}
