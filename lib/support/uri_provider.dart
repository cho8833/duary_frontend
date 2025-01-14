mixin UriProvider {
  static const String _scheme = "https";
  static const String _host = "i3lm91q9v5.execute-api.ap-northeast-2.amazonaws.com";
  // static const int _port = 8080;

  Uri getUri(String path, {Map<String, dynamic>? queryParameters}) {
    return Uri(
        scheme: _scheme,
        host: _host,
        path: "/dev$path",
        // port: _port,
        queryParameters: queryParameters);
  }
}
