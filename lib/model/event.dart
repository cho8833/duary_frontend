import 'package:duary/model/enums/repeat_frequency.dart';
import 'package:duary/model/member.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  String id;
  DateTime startDateTime;
  DateTime endDateTime;
  String? content;
  String title;
  int createdBy;
  bool isTogether;
  bool isAllDay;
  String coupleId;
  String? location;
  String? hangOutWith;
  Recurrence? recurrence;
  late Member member;

  Event(
      this.id,
    this.startDateTime,
    this.endDateTime,
    this.title,
    this.createdBy,
    this.isTogether,
    this.isAllDay,
    this.coupleId, {
    this.content,
    this.location,
    this.hangOutWith,
    this.recurrence,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

@JsonSerializable()
class Recurrence {
  RepeatFrequency frequency;
  int interval;
  DateTime repeatStartDate;
  DateTime repeatEndDate;


  Recurrence(
      this.frequency, this.interval, this.repeatStartDate, this.repeatEndDate);

  factory Recurrence.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceFromJson(json);
}
