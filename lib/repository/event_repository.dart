import 'package:duary/model/event.dart';

abstract interface class EventRepository {
  Future<List<Event>> getComingEvents();
}