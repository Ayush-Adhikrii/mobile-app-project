// lib/features/message/presentation/bloc/message_state.dart
import 'package:equatable/equatable.dart';

import '../../../domain/entities/match_entity.dart';
import '../../../domain/entities/message_entity.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {
  const MessageInitial();
}

class MessageLoading extends MessageState {
  const MessageLoading();
}

class MessageLoaded extends MessageState {
  final List<MatchEntity> matches;
  final List<MessageEntity> messages;
  final String? selectedMatchId;

  const MessageLoaded({
    required this.matches,
    required this.messages,
    this.selectedMatchId,
  });

  @override
  List<Object?> get props => [matches, messages, selectedMatchId];
}

class MessageError extends MessageState {
  final String message;

  const MessageError(this.message);

  @override
  List<Object?> get props => [message];
}