// lib/features/message/domain/usecases/get_matches_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';

import '../entities/match_entity.dart';
import '../repositories/message_repository.dart';

class GetMatchesUseCase {
  final MessageRepository repository;

  GetMatchesUseCase(this.repository);

  Future<Either<Failure, List<MatchEntity>>> call() async {
    return await repository.getMatches();
  }
}