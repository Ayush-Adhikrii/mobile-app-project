import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import '../entity/user_entity.dart';
import '../repository/user_repository.dart';

class GetUsersUseCase {
  final IUserRepository repository;

  GetUsersUseCase(this.repository);

  Future<Either<Failure, List<UserEntity>>> call() async {
    return await repository.getUsers();
  }
}
