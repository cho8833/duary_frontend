import 'package:device_calendar/device_calendar.dart' show Calendar;
import 'package:duary/model/event.dart';
import 'package:duary/provider/event_provider.dart';

extension AppleEventProvider on EventProvider {

  Future<bool> requestApplePermission() async {
    return await appleCalendarRepository.requestPermission();
  }

  Future<List<Calendar>> getAppleCalendars() {
    return appleCalendarRepository.getCalendars();
  }

  Future<List<Event>> getEvents(List<String> calendarIds, String memberId, DateTime startDate, DateTime endDate) async {
    final List<List<Event>> futures = await Future.wait(
      calendarIds.map((id) => appleCalendarRepository.getEvent(id, memberId, startDate, endDate))
    );

    List<Event> flattened = futures.expand((e) => e).toList();

    return flattened;
  }
}