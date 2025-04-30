import 'package:duary/model/couple.dart';
import 'package:duary/repository/couple_repository.dart';
import 'package:duary/support/http_response_handler.dart';
import 'package:duary/support/uri_provider.dart';
import 'package:http/http.dart';

class CoupleRepositoryImpl with UriProvider, HttpResponseHandler implements CoupleRepository {

  final Client client;

  CoupleRepositoryImpl(this.client);

  @override
  Future<Couple> getMyCouple() async {
    Uri uri = getUri("/couple");

    Response response = await client.get(uri);

    return getData(response, (data) => Couple.fromJson(data)).data;
  }
}