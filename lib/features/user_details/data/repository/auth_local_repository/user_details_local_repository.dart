import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entity/user_details_entity.dart';
import '../../../domain/repository/user_details_repository.dart';
import '../../data_source/local_data_source/user_details_local_data_source.dart';

class UserDetailsLocalRepository implements IUserDetailsRepository {
  final UserDetailsLocalDataSource _userDetailsLocalDataSource;

  UserDetailsLocalRepository(this._userDetailsLocalDataSource);

  @override
  Future<Either<Failure, void>> addDetails(UserDetailsEntity details) async {
    try {
      await _userDetailsLocalDataSource.addDetails(details);
      return const Right(null); // Return Right(null) for void operations
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetailsEntity>> getUserDetails() async {
    try {
      final userDetails = await _userDetailsLocalDataSource.getUserDetails();
      return Right(userDetails);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
