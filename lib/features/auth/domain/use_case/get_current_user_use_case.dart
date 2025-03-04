// lib/features/auth/domain/use_case/get_current_user_use_case.dart
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/auth_entity.dart';
import '../repository/auth_repository.dart';

class GetCurrentUserUseCase {
  final IAuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call() async {
    return await repository.getCurrentUser();
  }
}
