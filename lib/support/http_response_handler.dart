import 'dart:convert';

import 'package:http/http.dart';
import 'package:duary/base/server_response.dart';
import 'package:duary/support/custom_exception.dart';

mixin HttpResponseHandler {
  Map<String, dynamic> checkResponse(Response response) {
    if (response.statusCode == 403) {
      throw ForbiddenException();
    }
    late Map<String, dynamic> json;
    try {
      json = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw JsonParsingException();
    }
    if (response.statusCode == 200) {
      switch (json['status'] as int) {
        case 200:
          return json;
        case 400:
          throw ServerResponseException(json['message']);
        case 403:
          throw ForbiddenException();
        default:
          throw UnknownServerException(json['message']);
      }
    }
    throw UnknownServerException("unknown server error");
  }

  ServerResponse<T> getData<T>(
      Response response, T Function(Map<String, dynamic>) fromJson) {
    Map<String, dynamic> data = checkResponse(response);
    return ServerResponse.fromResponse(data, fromJson);
  }

  ServerResponse<PagedData<T>> getPagedData<T>(
      Response response, T Function(Map<String, dynamic>) fromJson) {
    Map<String, dynamic> data = checkResponse(response);
    return ServerPagedResponse.fromResponse(data, fromJson);
  }
}
