// lib/features/message/presentation/bloc/message_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/message_remote_repository.dart';
import '../../../domain/entities/match_entity.dart';
import '../../../domain/use_case/get_matches_use_case.dart';
import '../../../domain/use_case/send_message_use_case.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMatchesUseCase getMatchesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final MessageRepositoryImpl messageRepository;

  MessageBloc(this.getMatchesUseCase, this.sendMessageUseCase, this.messageRepository) : super(MessageInitial()) {
    on<FetchMatches>((event, emit) async {
      print('Fetching matches...');
      emit(MessageLoading());
      final result = await getMatchesUseCase();
      emit(result.fold(
        (failure) => MessageError(failure.message),
        (matches) => MessageLoaded(matches: matches, messages: [], selectedMatchId: null),
      ));
    });

    on<SelectMatch>((event, emit) async {
      print('Selecting match: ${event.matchId}');
      emit(MessageLoading());

      List<MatchEntity> matches = [];
      if (state is MessageLoaded) {
        matches = (state as MessageLoaded).matches;
      } else {
        final matchResult = await getMatchesUseCase();
        matches = matchResult.fold(
          (failure) {
            print('Failed to fetch matches: ${failure.message}');
            emit(MessageError(failure.message));
            return [];
          },
          (matchList) {
            print('Matches fetched: ${matchList.length}');
            return matchList;
          },
        );
      }

      final messageResult = await messageRepository.getMessages(event.matchId);
      print('Get messages result for ${event.matchId}: $messageResult');
      emit(messageResult.fold(
        (failure) {
          print('Failed to get messages: ${failure.message}');
          return MessageError(failure.message);
        },
        (messages) {
          print('Messages loaded: ${messages.length}');
          messageRepository.subscribeToMessages((message) {
            print('Subscribing to new messages for ${event.matchId}');
            add(NewMessageReceived(message));
          });
          return MessageLoaded(
            matches: matches,
            messages: messages,
            selectedMatchId: event.matchId,
          );
        },
      ));
    });

    on<SendMessage>((event, emit) async {
      print('Sending message to ${event.receiverId}: ${event.content}');
      if (state is MessageLoaded) {
        final currentState = state as MessageLoaded;
        final result = await sendMessageUseCase(event.receiverId, event.content);
        result.fold(
          (failure) {
            print('Failed to send message: ${failure.message}');
            emit(MessageError(failure.message));
          },
          (message) {
            print('Message sent successfully: ${message.content}');
            // Always add message locally, regardless of socket
            final updatedMessages = [...currentState.messages, message];
            emit(MessageLoaded(
              matches: currentState.matches,
              messages: updatedMessages,
              selectedMatchId: currentState.selectedMatchId,
            ));
                    },
        );
      }
    });

    on<NewMessageReceived>((event, emit) {
      print('New message received: ${event.message.content}');
      if (state is MessageLoaded) {
        final currentState = state as MessageLoaded;
        if (currentState.selectedMatchId == event.message.senderId ||
            currentState.selectedMatchId == event.message.id.split('-').last) {
          emit(MessageLoaded(
            matches: currentState.matches,
            messages: [...currentState.messages, event.message],
            selectedMatchId: currentState.selectedMatchId,
          ));
        }
      }
    });
  }

  @override
  Future<void> close() {
    messageRepository.unsubscribeFromMessages();
    return super.close();
  }
}