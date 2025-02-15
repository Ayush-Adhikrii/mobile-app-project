import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entity/user_details_entity.dart';
import '../../../domain/repository/user_details_repository.dart';
import '../../data_source/remote_data_source/user_details_remote_data_source.dart';

class UserDetailsRemoteRepository implements IUserDetailsRepository {
  final UserDetailsRemoteDataSource _userDetailsRemoteDataSource;

  UserDetailsRemoteRepository(this._userDetailsRemoteDataSource);

  @override
  Future<Either<Failure, void>> addDetails(UserDetailsEntity user) async {
    try {
      await _userDetailsRemoteDataSource.addDetails(user);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetailsEntity>> getUserDetails() async {
    try {
      final userDetails = await _userDetailsRemoteDataSource.getUserDetails();
      return Right(userDetails);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
