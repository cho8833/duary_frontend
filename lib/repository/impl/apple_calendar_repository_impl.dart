import 'package:device_calendar/device_calendar.dart';
import 'package:duary/model/event.dart' as duary;
import 'package:duary/model/member.dart';
import 'package:duary/repository/apple_calendar_repository.dart';
import 'package:duary/support/custom_exception.dart';

final class AppleCalendarRepositoryImpl implements AppleCalendarRepository {
  final DeviceCalendarPlugin _plugin = DeviceCalendarPlugin();

  @override
  Future<List<Calendar>> getCalendars() async {
    try {
      final calendarResult = await _plugin.retrieveCalendars();
      return calendarResult.data as List<Calendar>;
    } catch (e) {
      throw PermissionDeniedException("권한을 허용해주세요.");
    }

  }

  @override
  Future<List<duary.Event>> getEvent(AppleCalendar appleCalendar, String memberId, String? loverId,
      DateTime startDate, DateTime endDate) async {
    try {
      final eventResult = await _plugin.retrieveEvents(appleCalendar.id,
          RetrieveEventsParams(startDate: startDate, endDate: endDate));

      List<Event> events = eventResult.data as List<Event>;

      return events.map((e) => duary.Event.fromApple(appleCalendar, memberId, loverId,  e)).toList();
    } catch (e) {
      throw PermissionDeniedException("권한을 허용해주세요.");
    }
  }

  @override
  Future<bool> getPermission() async {
    try {
      var permissionGranted = await _plugin.hasPermissions();
      if (permissionGranted.isSuccess &&
          (permissionGranted.data == null || permissionGranted.data == false)) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      var permissionGranted = await getPermission();
      if (!permissionGranted) {
        var permissionRequested = await _plugin.requestPermissions();
        if (!permissionRequested.isSuccess ||
            permissionRequested.data == null ||
            permissionRequested.data == false) {
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
