// lib/features/user_details/domain/use_case/update_user_details_use_case.dart
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repository/user_details_repository.dart';

class UpdateUserDetailsUseCase {
  final IUserDetailsRepository repository;

  UpdateUserDetailsUseCase(this.repository);

  Future<Either<Failure, void>> call(
      String userId, String key, String value) async {
    return await repository.updateUserDetails(userId, key, value);
  }
}
