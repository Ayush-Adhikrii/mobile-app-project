import 'package:equatable/equatable.dart';

import '../../../domain/entities/message_entity.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class FetchMatches extends MessageEvent {}

class SelectMatch extends MessageEvent {
  final String matchId;

  const SelectMatch(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class SendMessage extends MessageEvent {
  final String receiverId;
  final String content;

  const SendMessage(this.receiverId, this.content);

  @override
  List<Object?> get props => [receiverId, content];
}

class NewMessageReceived extends MessageEvent {
  final MessageEntity message;

  const NewMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}