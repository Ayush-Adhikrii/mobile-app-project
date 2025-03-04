import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import '../entity/user_entity.dart';
import '../repository/user_repository.dart';

class GetLikersUseCase {
  final IUserRepository repository;

  GetLikersUseCase(this.repository);

  Future<Either<Failure, List<UserEntity>>> call(String userId) async {
    return await repository.getLikers(userId);
  }
}