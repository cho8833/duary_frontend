enum WSAction {
  coupleConnected("COUPLE_CONNECTED"),
  eventCreated("EVENT_CREATED"),
  eventDeleted("EVENT_DELETED"),
  eventUpdated("EVENT_UPDATED"),
  loverUpdated("LOVER_UPDATED");

  const WSAction(this.value);

  final String value;

  factory WSAction.fromJson(String value) =>
      WSAction.values.firstWhere((a) => a.value == value);
}

class WebSocketData<T> {
  WSAction action;
  T data;

  WebSocketData(this.action, this.data);

  factory WebSocketData.fromJson(
      dynamic json, T Function(Map<String, dynamic>) fromJson) {
    return WebSocketData(
        WSAction.fromJson(json['action'] as String), fromJson(json['data']));
  }
}
