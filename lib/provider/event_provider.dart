import 'package:duary/model/event.dart';
import 'package:duary/repository/event_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:status_builder/status_builder.dart';

class EventProvider {
  List<Event> comingEvents = [];
  ValueNotifier<Status> comingEventStatus = ValueNotifier(Status.loading);
  String comingEventErrorMessage = "";

  EventRepository eventRepository;

  EventProvider(this.eventRepository);

  Future<void> getComingEvent() async {
    if (comingEventStatus.value != Status.success) {
      comingEventStatus.value = Status.loading;
    }

    await eventRepository.getComingEvents().then((events) {
      comingEvents = events;
      comingEventStatus.value = Status.success;
    }).catchError((e) {
      comingEventErrorMessage = e.toString();
      comingEventStatus.value = Status.fail;
    });
  }
}