import 'package:device_calendar/device_calendar.dart' show Calendar;
import 'package:duary/model/event.dart';
import 'package:duary/model/member.dart';
import 'package:duary/model/third_party_calendar.dart';

abstract interface class AppleCalendarRepository {

  Future<List<Event>> getEvent(AppleCalendar appleCalendar, String memberId, String? loverId,
      DateTime startDate, DateTime endDate);

  Future<List<Calendar>> getCalendars();

  Future<bool> requestPermission();

  Future<bool> getPermission();

}