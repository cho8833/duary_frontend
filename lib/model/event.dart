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
  int coupleId;
  String? location;
  String? meetWith;


  Event(this.id, this.startDateTime, this.endDateTime, this.title,
      this.member, this.isTogether, this.coupleId, {this.location, this.meetWith, this.content});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}