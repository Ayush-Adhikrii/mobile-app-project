// lib/features/user_details/domain/use_case/get_user_details_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entity/user_details_entity.dart';
import '../repository/user_details_repository.dart';

class GetUserDetailsUseCase {
  final IUserDetailsRepository repository;

  GetUserDetailsUseCase(this.repository);

  Future<Either<Failure, UserDetailsEntity>> call({required String userId}) async {
    return await repository.getUserDetails(userId: userId);
  }
}