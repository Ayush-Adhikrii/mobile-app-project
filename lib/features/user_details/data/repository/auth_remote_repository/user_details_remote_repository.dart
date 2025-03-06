import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/data_source/local_data_source/user_details_local_data_source.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/data_source/remote_data_source/user_details_remote_data_source.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/model/user_details_api_model.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/entity/user_details_entity.dart';

class UserDetailsRemoteRepository {
  final UserDetailsRemoteDataSource _remoteDataSource;
  final UserDetailsLocalDataSource _localDataSource;

  UserDetailsRemoteRepository(this._remoteDataSource, this._localDataSource);

  Future<Either<Failure, void>> addUserDetails(UserDetailsEntity user) async {
    try {
      final model = UserDetailsApiModel.fromEntity(user);
      await _remoteDataSource.addUserDetails(model);
      // Cache the added user details in Hive
      await _localDataSource.addUserDetails(user);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: "Failed to add user details: $e"));
    }
  }

  Future<Either<Failure, UserDetailsEntity>> getUserDetails(String userId) async {
    try {
      final model = await _remoteDataSource.getUserDetails(userId);
      final entity = model.toEntity();
      // Cache the fetched user details in Hive
      await _localDataSource.addUserDetails(entity);
      return Right(entity);
    } catch (e) {
      return Left(ApiFailure(message: "Failed to fetch user details: $e"));
    }
  }

  Future<Either<Failure, void>> updateUserDetails(String userId, String key, String value) async {
    try {
      await _remoteDataSource.updateUserDetails(userId, key, value);
      // Fetch the updated user details and cache them in Hive
      final updatedModel = await _remoteDataSource.getUserDetails(userId);
      await _localDataSource.addUserDetails(updatedModel.toEntity());
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: "Failed to update user details: $e"));
    }
  }
}