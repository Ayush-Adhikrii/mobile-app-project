import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/data_source/local_data_source/user_details_local_data_source.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/entity/user_details_entity.dart';

class UserDetailsLocalRepository {
  final UserDetailsLocalDataSource _localDataSource;

  UserDetailsLocalRepository(this._localDataSource);

  Future<Either<Failure, void>> addUserDetails(UserDetailsEntity user) async {
    try {
      await _localDataSource.addUserDetails(user);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to add user details locally: $e"));
    }
  }

  Future<Either<Failure, UserDetailsEntity>> getUserDetails(String userId) async {
    try {
      final entity = await _localDataSource.getUserDetails(userId);
      return Right(entity);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to fetch user details from local storage: $e"));
    }
  }

  Future<Either<Failure, void>> updateUserDetails(String userId, String key, String value) async {
    try {
      await _localDataSource.updateUserDetails(userId, key, value);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to update user details locally: $e"));
    }
  }
}