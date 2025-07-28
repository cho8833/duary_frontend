import 'package:duary/data/event_req.dart';
import 'package:duary/model/event.dart';

abstract interface class EventRepository {

  Future<List<Event>> getEvent(String coupleId, DateTime startDate, DateTime endDate);

  Future<Event> saveEvent(SaveEventReq req);

  Future<Event> editEvent(String id, SaveEventReq req);

  Future<void> deleteEvent(String eventId);

}