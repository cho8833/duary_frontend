
import 'package:duary/model/enums/frequency.dart';
import 'package:duary/model/event.dart';
import 'package:duary/support/iso8601_time_zone_formatter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'save_event_req.g.dart';

@JsonSerializable(createFactory: false)
class SaveEventReq {

  @ISO8601TimeZoneFormatter()
  DateTime startDateTime;

  @ISO8601TimeZoneFormatter()
  DateTime endDateTime;

  @ISO8601TimeZoneFormatter()
  DateTime? recurStartDate;

  @ISO8601TimeZoneFormatter()
  DateTime? recurEndDate;

  Frequency frequency;
  DailyRecurrence? daily;
  WeeklyRecurrence? weekly;
  MonthlyRecurrence? monthly;
  YearlyRecurrence? yearly;

  String title;
  String? content;
  String? location;
  String? hangOutWith;

  bool isTogether;
  bool isAllday;

  SaveEventReq(
      this.startDateTime,
      this.endDateTime,
      this.recurStartDate,
      this.recurEndDate,
      this.frequency,
      this.daily,
      this.weekly,
      this.monthly,
      this.yearly,
      this.title,
      this.content,
      this.location,
      this.hangOutWith,
      this.isTogether,
      this.isAllday);


  Map<String, dynamic> toJson() => _$SaveEventReqToJson(this);
}