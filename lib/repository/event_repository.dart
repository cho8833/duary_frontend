import 'package:duary/model/event.dart';

abstract interface class EventRepository {
  Future<List<Event>> getComingEvents();

  Future<List<Event>> getEvent(DateTime day);

}