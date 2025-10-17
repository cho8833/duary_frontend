part of 'event_provider.dart';


extension AppleCalendarProvider on EventProvider {

  Future<void> removeSyncedAppleCalendar(String id) async {
    List<AppleCalendar> current = List.from(appleCalendars.value);

    current.removeWhere((c) => c.id == id);

    await localStorage.storeAppleCalendar(current);

    appleCalendars.value = current;

    // remove cached events
    _clearData();
  }

  Future<void> updateSyncedAppleCalendar(AppleCalendar calendar) async {
    List<AppleCalendar> current = List.from(appleCalendars.value);

    bool isUpdate = current.where((c) => c.id == calendar.id).isNotEmpty;

    if (isUpdate) {
      // update - remove and add
      current.removeWhere((c) => c.id == calendar.id);
    }
    current.add(calendar);

    await localStorage.storeAppleCalendar(current);

    appleCalendars.value = current;

    // remove cached events
    _clearData();
  }

  Future<void> getSyncedAppleCalendar() async {
    List<AppleCalendar> synced =  await localStorage.getAppleCalendar();
    appleCalendars.value = synced;
  }

  Future<bool> requestApplePermission() async {
    return await appleCalendarRepository.requestPermission();
  }

  Future<bool> getApplePermission() async {
    return await appleCalendarRepository.getPermission();
  }

  Future<List<dc.Calendar>> getAppleCalendars() {
    return appleCalendarRepository.getCalendars();
  }

  Future<List<Event>> _getAppleEvents(
      String memberId,
      String? loverId,
      DateTime startDate,
      DateTime endDate) async {

    final List<List<Event>> futures = await Future.wait(appleCalendars.value.map((c) =>
        appleCalendarRepository.getEvent(
            c, memberId, loverId, startDate, endDate)));

    List<Event> flattened = futures.expand((e) => e).toList();

    return flattened;
  }
}
