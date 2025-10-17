import 'package:duary/model/enums/frequency.dart';
import 'package:duary/model/event.dart';
import 'package:duary/support/custom_exception.dart';
import 'package:duary/support/iso8601_time_zone_formatter.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_req.g.dart';

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
  bool isAllDay;

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
      this.isAllDay);

  Map<String, dynamic> toJson() => _$SaveEventReqToJson(this);

  void validate() {

    if (isAllDay) {
      startDateTime = startDateTime.copyWith(hour: 0, minute: 0);
      endDateTime = endDateTime.copyWith(hour: 23, minute: 59);
    }


    if (title.isEmpty) {
      throw ValidationException("제목을 입력해주세요");
    }
    if (startDateTime.isAfter(endDateTime)) {
      throw ValidationException("시작 시간은 종료 시간 보다 이전일 수 없습니다");
    }
    if (endDateTime.difference(startDateTime).inMinutes < 5) {
      throw ValidationException("일정 진행 시간은 5분보다 길어야 합니다");
    }
    switch (frequency) {
      case Frequency.daily:
        weekly = null;
        monthly = null;
        yearly = null;
      case Frequency.weekly:
        daily = null;
        monthly = null;
        yearly = null;
      case Frequency.monthly:
        daily = null;
        weekly = null;
        yearly = null;
      case Frequency.yearly:
        daily = null;
        weekly = null;
        monthly = null;
        yearly = YearlyRecurrence(startDateTime.month, startDateTime.day);
      case Frequency.oneTime:
        daily = null;
        weekly = null;
        monthly = null;
        yearly = null;
    }
  }
}