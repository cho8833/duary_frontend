import 'package:device_calendar/device_calendar.dart' show Calendar;
import 'package:duary/model/event.dart';

abstract interface class AppleCalendarRepository {

  Future<List<Event>> getEvent(
      String calendarId, String memberId, DateTime startDate, DateTime endDate);

  Future<List<Calendar>> getCalendars();

  Future<bool> requestPermission();

  Future<bool> getPermission();

}