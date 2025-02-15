import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/user_details_entity.dart';

abstract interface class IUserDetailsRepository {
  Future<Either<Failure, void>> addDetails(UserDetailsEntity user);

  Future<Either<Failure, UserDetailsEntity>> getUserDetails();
}
