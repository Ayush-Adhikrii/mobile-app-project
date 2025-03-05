// lib/core/services/socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../app/constants/api_endpoints.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? _socket;

  io.Socket get socket {
    if (_socket == null) {
      _connect();
    }
    return _socket!;
  }

  void _connect() {
    _socket = io.io(ApiEndpoints.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Connected to WebSocket server');
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from WebSocket server');
    });

    _socket!.onConnectError((error) {
      print('WebSocket connection error: $error');
    });
  }

  void subscribeToNewMatches(Function(dynamic) onNewMatch) {
    socket.on('newMatch', onNewMatch);
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}