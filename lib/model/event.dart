import 'package:duary/model/enums/repeat_frequency.dart';
import 'package:duary/model/member.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  int id;
  DateTime startDateTime;
  DateTime endDateTime;
  String? content;
  String title;
  Member member;
  bool isTogether;
  bool isAllDay;
  int coupleId;
  String? location;
  String? meetWith;
  Repeat? repeat;


  Event(this.id, this.startDateTime, this.endDateTime, this.title,
      this.member, this.isTogether, this.coupleId, this.isAllDay, {this.location, this.meetWith, this.content, this.repeat});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

@JsonSerializable()
class Repeat {
  RepeatFrequency frequency;

  Repeat(this.frequency);

  factory Repeat.fromJson(Map<String, dynamic> json) => _$RepeatFromJson(json);
}