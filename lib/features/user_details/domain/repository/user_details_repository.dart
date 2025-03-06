import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entity/user_details_entity.dart';

abstract interface class IUserDetailsRepository {
  Future<Either<Failure, void>> addUserDetails(UserDetailsEntity user);
  Future<Either<Failure, UserDetailsEntity>> getUserDetails({required String userId});
  Future<Either<Failure, void>> updateUserDetails(String userId, String key, String value);
}