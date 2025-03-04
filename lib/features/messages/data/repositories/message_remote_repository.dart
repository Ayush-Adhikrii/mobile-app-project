// lib/features/message/data/repositories/message_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';

import '../../domain/entities/match_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../data_source/message_remote_data_source.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MatchEntity>>> getMatches() async {
    try {
      final matches = await remoteDataSource.getMatches();
      return Right(matches);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
      String userId) async {
    try {
      final messages = await remoteDataSource.getMessages(userId);
      return Right(messages);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(
      String receiverId, String content) async {
    try {
      final message = await remoteDataSource.sendMessage(receiverId, content);
      return Right(message);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  void subscribeToMessages(Function(MessageEntity) onMessageReceived) {
    remoteDataSource.subscribeToMessages(onMessageReceived);
  }

  @override
  void unsubscribeFromMessages() {
    remoteDataSource.unsubscribeFromMessages();
  }
}
