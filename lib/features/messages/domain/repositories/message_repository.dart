import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import '../entities/match_entity.dart';
import '../entities/message_entity.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<MatchEntity>>> getMatches();
  Future<Either<Failure, List<MessageEntity>>> getMessages(String userId);
  Future<Either<Failure, MessageEntity>> sendMessage(String receiverId, String content); // Updated
  void subscribeToMessages(Function(MessageEntity) onMessageReceived);
  void unsubscribeFromMessages();
}