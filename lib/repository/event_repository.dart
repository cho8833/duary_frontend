import 'package:duary/model/event.dart';

abstract interface class EventRepository {

  Future<List<Event>> getEvent(String coupleId, DateTime startDate, DateTime endDate);

}