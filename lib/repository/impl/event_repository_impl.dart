import 'dart:convert';

import 'package:duary/data/event_req.dart';
import 'package:duary/model/event.dart';
import 'package:duary/repository/event_repository.dart';
import 'package:duary/support/http_response_handler.dart';
import 'package:duary/support/iso8601_time_zone_formatter.dart';
import 'package:duary/support/uri_provider.dart';
import 'package:http/http.dart';

class EventRepositoryImpl with UriProvider, HttpResponseHandler implements EventRepository {

  final Client interceptedClient;

  EventRepositoryImpl(this.interceptedClient);

  @override
  Future<List<Event>> getEvent(String coupleId, DateTime startDate, DateTime endDate) async {
    const ISO8601TimeZoneFormatter formatter = ISO8601TimeZoneFormatter();
    Uri uri = getUri("/event", queryParameters: {
      "coupleId": coupleId,
      "startDate": formatter.toJson(startDate),
      "endDate": formatter.toJson(endDate)
    });

    Response response = await interceptedClient.get(uri);

    return getListData(response, (p0) => Event.fromJson(p0)).data;
  }

  @override
  Future<Event> saveEvent(SaveEventReq req) async {
    Uri uri = getUri("/event");

    Response response = await interceptedClient.post(uri, body: jsonEncode(req.toJson()));

    return getData(response, (p) => Event.fromJson(p)).data;
  }

  @override
  Future<Event> editEvent(String id, SaveEventReq req) async {
    Uri uri = getUri("/event", queryParameters: {
      "id": id
    });

    Response response = await interceptedClient.put(uri, body: jsonEncode(req.toJson()));

    return getData(response, (p) => Event.fromJson(p)).data;
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    Uri uri = getUri("/event", queryParameters: {
      "id": eventId
    });

    Response response = await interceptedClient.delete(uri);

    checkResponse(response);
  }
}