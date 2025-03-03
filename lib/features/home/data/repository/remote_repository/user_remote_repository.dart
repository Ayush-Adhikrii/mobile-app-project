import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import '../../../domain/entity/user_entity.dart';
import '../../data_source/remote_datasource/user_remote_datasource.dart';
import '../../../domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRemoteRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    try {
      final users = await remoteDataSource.getUsers();
      return Right(users);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> swipeLeft(String userId) async {
    try {
      await remoteDataSource.swipeLeft(userId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> swipeRight(String userId) async {
    try {
      await remoteDataSource.swipeRight(userId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message:  e.toString()));
    }
  }
}