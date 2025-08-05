import 'dart:async';
import 'dart:convert';

import 'package:duary/base/ws_data.dart';
import 'package:duary/data/duary_info_res.dart';
import 'package:duary/provider/token_provider.dart';
import 'package:duary/support/uri_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum ConnectionStatus { disconnected, connecting, connected }

final class WebSocketHandler with UriProvider {
  static final WebSocketHandler _instance = WebSocketHandler._internal();

  factory WebSocketHandler() => _instance;

  WebSocketHandler._internal();

  WebSocketChannel? _channel;

  late final TokenProvider tokenProvider;

  void init(TokenProvider tp) {
    tokenProvider = tp;
  }

  ValueNotifier<DuaryInfoRes?> duaryInfoNotifier = ValueNotifier(null);

  ConnectionStatus _status = ConnectionStatus.disconnected;
  Timer? _reconnectTimer;

  bool isManuallyDisconnected = false;

  Future<void> connect() async {
    if (_status == ConnectionStatus.connected ||
        _status == ConnectionStatus.connecting) {
      return; // 이미 연결되었거나 시도 중이면 무시
    }

    _status = ConnectionStatus.connecting;

    _channel = WebSocketChannel.connect(getWSUri(
        queryParameters: {"Authorization": await tokenProvider.accessToken}));

    isManuallyDisconnected = false;

    print("웹소켓 연결");
    _channel!.stream.listen(
      (message) {
        // 연결이 성공적으로 이루어지면 상태를 'connected'로 변경
        if (_status != ConnectionStatus.connected) {
          _status = ConnectionStatus.connected;
        }
        _reconnectTimer?.cancel(); // 재연결 타이머가 있다면 취소
        _handle(message);
      },
      onDone: () {
        print("웹소켓 연결 종료.");
        _status = ConnectionStatus.disconnected;
        if (!isManuallyDisconnected) {
          _scheduleReconnect(); // 연결이 끊어지면 재연결 시도
        }
      },
      onError: (error) {
        print("웹소켓 오류: $error");
        _status = ConnectionStatus.disconnected;
        if (!isManuallyDisconnected) {
          _scheduleReconnect(); // 연결이 끊어지면 재연결 시도
        }
      },
      cancelOnError: true,
    );
  }

  void _handle(dynamic data) {
    final decoded = jsonDecode(data);
    final WSAction action = WSAction.fromJson(decoded['action']);
    switch (action) {
      case WSAction.coupleConnected:
        final value = DuaryInfoRes.fromJson(decoded['data']);
        duaryInfoNotifier.value = value;

      default:
        return;
    }
  }

  void disconnect() {
    isManuallyDisconnected = true;
    _reconnectTimer?.cancel(); // 재연결 시도 중단
    _channel?.sink.close();
    _status = ConnectionStatus.disconnected;
  }

  void _scheduleReconnect() {
    if (_reconnectTimer?.isActive ?? false) return; // 이미 재연결 스케줄이 있으면 무시

    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      connect();
    });
  }
}
