import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String content;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object?> get props => [id, senderId, content];
}