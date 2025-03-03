// lib/features/message/domain/usecases/send_message_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';

import '../entities/message_entity.dart';
import '../repositories/message_repository.dart';

class SendMessageUseCase {
  final MessageRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, MessageEntity>> call(String receiverId, String content) async {
    return await repository.sendMessage(receiverId, content);
  }
}