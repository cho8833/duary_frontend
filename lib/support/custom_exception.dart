class UnknownServerException implements Exception {
  final String message;

  UnknownServerException(this.message);

  @override
  String toString() => "알 수 없는 서버 오류";
}

class ServerResponseException implements Exception {
  final String message;

  ServerResponseException(this.message);

  factory ServerResponseException.fromException(Exception e) {
    return ServerResponseException(e.toString());
  }

  @override
  String toString() => message;
}

class CustomException implements Exception {
  final String message;

  CustomException(this.message);

  @override
  String toString() {
    return message;
  }
}

class EmptyListException implements Exception {
  String? message;

  EmptyListException({this.message});

  @override
  String toString() => message ?? "no data";
}

class JsonParsingException implements Exception {
  String? message;

  JsonParsingException({this.message});

  @override
  String toString() {
    return message ?? "error occurred parsing json";
  }
}

class ForbiddenException implements Exception {
  @override
  String toString() {
    return '권한이 없습니다';
  }
}

class TypeException implements Exception {
  String? message;

  TypeException({this.message});

  @override
  String toString() => message ?? "type error";
}

class ConnectionException implements Exception {
  @override
  String toString() {
    return "서버와의 연결이 끊어졌습니다";
  }
}

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() {
    return message;
  }
}

class PermissionDeniedException implements Exception {
  final String message;

  PermissionDeniedException(this.message);

  @override
  String toString() {
    return message;
  }
}