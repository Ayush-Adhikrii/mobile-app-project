import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';

import '../../domain/entities/message_entity.dart';
import '../models/match_model.dart';
import '../models/message_model.dart';

abstract class MessageRemoteDataSource {
  Future<List<MatchModel>> getMatches();
  Future<List<MessageEntity>> getMessages(String userId);
  Future<MessageEntity> sendMessage(String receiverId, String content);
  void subscribeToMessages(Function(MessageEntity) onMessageReceived);
  void unsubscribeFromMessages();
  void dispose();
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final Dio _dio;
  late socket_io.Socket _socket;
  final String userId;
  final String socketUrl =
      'http://${ApiEndpoints.ipAddress}:5000'; 

  MessageRemoteDataSourceImpl(this._dio, this.userId) {
    _initializeSocket();
  }

  void _initializeSocket() {
    try {
      _socket = socket_io.io(
        socketUrl,
        socket_io.OptionBuilder()
            .setTransports(['websocket'])
            .setTimeout(10000)
            .enableForceNew()
            .setAuth({'userId': userId}) // Pass userId
            .build(),
      );
      _socket.onConnect((_) => print('Socket connected successfully'));
      _socket.onDisconnect((_) => print('Socket disconnected'));
      _socket.onConnectError((data) => print('Socket connect error: $data'));
      _socket.onError((data) => print('Socket error: $data'));
      _socket.connect();
      // Retry connection if initial attempt fails
      _socket.onConnectError((_) {
        print('Retrying socket connection in 2 seconds...');
        Future.delayed(const Duration(seconds: 2), () {
          if (!_socket.connected) _socket.connect();
        });
      });
    } catch (e) {
      print('Socket initialization failed: $e');
    }
  }

  @override
  Future<List<MatchModel>> getMatches() async {
    try {
      final response = await _dio.get('${ApiEndpoints.baseUrl}matches');
      print('getMatches response: ${response.statusCode}, ${response.data}');
      if (response.statusCode == 200) {
        final matches = response.data['matches'] as List;
        print('matches are $matches');
        final matchList = <MatchModel>[];
        for (var json in matches) {
          try {
            print('Parsing match: $json');
            matchList.add(MatchModel(
              id: json['_id'] as String? ?? 'unknown',
              name: json['name'] as String? ?? 'Unnamed',
              profilePhoto: json['profilePhoto'] as String?,
            ));
            print('Parsing add: $matchList');
          } catch (e) {
            print('Error parsing match: $e');
          }
        }
        print('Parsed matches: $matchList');
        return matchList;
      } else {
        throw Exception('Failed to fetch matches: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in getMatches: ${e.message}, Response: ${e.response?.data}');
      throw Exception(
          'Failed to fetch matches: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      print('Unexpected error in getMatches: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<MessageEntity>> getMessages(String userId) async {
    try {
      final response = await _dio
          .get('${ApiEndpoints.baseUrl}messages/conversation/$userId');
      print('getMessages response: ${response.statusCode}, ${response.data}');
      if (response.statusCode == 200) {
        final messages = response.data['messages'] as List;
        final messageList = <MessageEntity>[];
        for (var json in messages) {
          try {
            print('Parsing message: $json');
            messageList.add(MessageModel(
              id: json['_id'] as String? ?? 'unknown',
              senderId: json['sender'] as String? ?? 'unknown',
              content: json['content'] as String? ?? '',
            ));
          } catch (e) {
            print('Error parsing message: $e');
          }
        }
        print('Parsed messages: $messageList');
        return messageList;
      } else {
        throw Exception('Failed to fetch messages: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in getMessages: ${e.message}, Response: ${e.response?.data}');
      throw Exception(
          'Failed to fetch messages: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      print('Unexpected error in getMessages: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<MessageEntity> sendMessage(String receiverId, String content) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}messages/send',
        data: {'receiverId': receiverId, 'content': content},
      );
      print('sendMessage response: ${response.statusCode}, ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final messageJson = response.data['message'] as Map<String, dynamic>;
        final message = MessageModel(
          id: messageJson['_id'] as String? ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: messageJson['sender'] as String? ?? 'unknown',
          content: messageJson['content'] as String? ?? '',
        );
        if (_socket.connected) {
          _socket.emit('sendMessage', {
            'receiverId': receiverId,
            'content': content,
            'sender': messageJson['sender'] ?? 'unknown',
            '_id': messageJson['_id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
          });
          print('Message emitted via socket: $content');
        } else {
          print('Socket not connected, skipping emit');
        }
        return message; // Return the MessageEntity
      } else {
        throw Exception('Failed to send message: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in sendMessage: ${e.message}, Response: ${e.response?.data}');
      throw Exception(
          'Failed to send message: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      print('Unexpected error in sendMessage: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  void subscribeToMessages(Function(MessageEntity) onMessageReceived) {
    if (_socket.connected) {
      _socket.on('newMessage', (data) {
        final messageData = data['message'] as Map<String, dynamic>;
        final message = MessageModel(
          id: messageData['_id'] as String? ?? 'unknown',
          senderId: messageData['sender'] as String? ?? 'unknown',
          content: messageData['content'] as String? ?? '',
        );
        print('New message received via socket: ${message.content}');
        onMessageReceived(message);
      });
    } else {
      print('Socket not connected, cannot subscribe to messages');
    }
  }

  @override
  void unsubscribeFromMessages() {
    _socket.off('newMessage');
    print('Unsubscribed from messages');
  }

  @override
  void dispose() {
    _socket.disconnect();
    print('Socket disposed');
  }
}
