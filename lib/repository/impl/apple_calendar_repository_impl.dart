import 'package:device_calendar/device_calendar.dart';
import 'package:duary/model/event.dart' as duary;
import 'package:duary/repository/apple_calendar_repository.dart';
import 'package:duary/support/custom_exception.dart';

final class AppleCalendarRepositoryImpl implements AppleCalendarRepository {
  final DeviceCalendarPlugin _plugin = DeviceCalendarPlugin();

  @override
  Future<List<Calendar>> getCalendars() async {
    if (!await requestPermission()) {
      throw PermissionDeniedException("권한을 허용해주세요");
    }

    final calendarResult = await _plugin.retrieveCalendars();

    return calendarResult.data as List<Calendar>;
  }

  @override
  Future<List<duary.Event>> getEvent(String calendarId, String memberId,
      DateTime startDate, DateTime endDate) async {
    if (!await requestPermission()) {
      throw PermissionDeniedException("권한을 허용해주세요");
    }

    final eventResult = await _plugin.retrieveEvents(calendarId,
        RetrieveEventsParams(startDate: startDate, endDate: endDate));

    List<Event> events = eventResult.data as List<Event>;

    return events.map((e) => duary.Event.fromApple(memberId, e)).toList();
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
