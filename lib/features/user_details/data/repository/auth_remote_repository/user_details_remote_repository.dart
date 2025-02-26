// lib/features/user_details/data/repository/user_details_repository_impl.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entity/user_details_entity.dart';
import '../../../domain/repository/user_details_repository.dart';
import '../../data_source/remote_data_source/user_details_remote_data_source.dart';
import '../../model/user_details_api_model.dart';

class UserDetailsRepositoryImpl implements IUserDetailsRepository {
  final UserDetailsRemoteDataSource remoteDataSource;

  UserDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> addUserDetails(UserDetailsEntity user) async {
    try {
      final model = UserDetailsApiModel.fromEntity(user);
      await remoteDataSource.addUserDetails(model);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: "Failed to add user details: $e"));
    }
  }

  @override
  Future<Either<Failure, UserDetailsEntity>> getUserDetails(
      {required String userId}) async {
    try {
      final model = await remoteDataSource.getUserDetails(userId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: "Failed to fetch user details: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserDetails(String userId,String key, String value) async {
    try {
      await remoteDataSource.updateUserDetails(userId,key, value);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message:"Failed to update user details: $e"));
    }
  }
}
