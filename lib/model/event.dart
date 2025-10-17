import 'package:duary/model/enums/frequency.dart';
import 'package:device_calendar/device_calendar.dart' as dc;
import 'package:duary/model/enums/weekday.dart';
import 'package:duary/model/member.dart';
import 'package:duary/model/third_party_calendar.dart';
import 'package:duary/support/iso8601_time_zone_formatter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
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

  Map<String, dynamic> toJson() => _$EventToJson(this);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  factory Event.fromApple(AppleCalendar calendar, String memberId,
      String? loverId, dc.Location location, dc.Event dcEvent) {
    String createdBy =
        calendar.owner == CalendarOwner.lover ? (loverId ?? "lover") : memberId;
    bool isTogether = calendar.owner == CalendarOwner.together;
    Event event = Event(
        dcEvent.eventId!,
        "",
        createdBy,
        dc.TZDateTime.from(dcEvent.start!, location),
        dc.TZDateTime.from(dcEvent.end!, location),
        dcEvent.title!,
        Frequency.oneTime,
        isTogether,
        dcEvent.allDay!,
        EventType.apple);

    return event;
  }

  factory Event.copy(Event event) {
    return Event(
        event.id,
        event.coupleId,
        event.createdBy,
        event.startDateTime,
        event.endDateTime,
        event.title,
        event.frequency,
        event.isTogether,
        event.isTogether,
        event.eventType,
      recurStartDate: event.recurStartDate,
      recurEndDate: event.recurEndDate,
      daily: event.daily,
      weekly: event.weekly,
      monthly: event.monthly,
      yearly: event.yearly,
      content: event.content,
      location: event.location,
      hangOutWith: event.hangOutWith
    );
  }

  @override
  bool operator ==(covariant Event other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  bool hasChange(Event? event) {
    if (event == null) {
      return true;
    }
    if (id != event.id) return true;
    if (coupleId != event.coupleId) return true;
    if (createdBy != event.createdBy) return true;
    if (startDateTime != event.startDateTime) return true;
    if (endDateTime != event.endDateTime) return true;
    if (frequency != event.frequency) return true;
    if (recurStartDate != event.recurStartDate) return true;
    if (recurEndDate != event.recurEndDate) return true;
    if (daily != event.daily) return true;
    if (weekly != event.weekly) return true;
    if (monthly != event.monthly) return true;
    if (yearly != event.yearly) return true;
    if (recurCount != event.recurCount) return true;
    if (title != event.title) return true;
    if (content != event.content) return true;
    if (location != event.location) return true;
    if (hangOutWith != event.hangOutWith) return true;
    if (isTogether != event.isTogether) return true;
    if (isAllDay != event.isAllDay) return true;
    if (eventType != event.eventType) return true;

    return false;
  }
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
  apple("APPLE"),
  anniversary("ANNIVERSARY");

  final String value;

  const EventType(this.value);

  factory EventType.fromJson(String json) =>
      EventType.values.firstWhere((t) => t.value == json);
}
