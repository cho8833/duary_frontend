mixin UriProvider {
  static const String _scheme = "http";
  static const String _host = "localhost";
  static const int _port = 8080;

  Uri getUri(String path, {Map<String, dynamic>? queryParameters}) {
    return Uri(
        scheme: _scheme,
        host: _host,
        path: path,
        port: _port,
        queryParameters: queryParameters);
  }
}
