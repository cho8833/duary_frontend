import 'package:duary/model/event.dart';
import 'package:duary/repository/event_repository.dart';
import 'package:duary/support/http_response_handler.dart';
import 'package:duary/support/uri_provider.dart';
import 'package:http/http.dart';

class EventRepositoryImpl with UriProvider, HttpResponseHandler implements EventRepository {

  final Client interceptedClient;

  EventRepositoryImpl(this.interceptedClient);

  @override
  Future<List<Event>> getEvent(String coupleId, DateTime startDate, DateTime endDate) async {
    Uri uri = getUri("/event", queryParameters: {
      "coupleId": coupleId,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String()
    });

    Response response = await interceptedClient.get(uri);

    return getListData(response, (p0) => Event.fromJson(p0)).data;
  }

}