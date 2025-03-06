import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entity/user_details_entity.dart';
import '../repository/user_details_repository.dart';

class AddUserDetailsUseCase {
  final IUserDetailsRepository repository;

  AddUserDetailsUseCase(this.repository);

  Future<Either<Failure, void>> call(UserDetailsEntity details) async {
    return await repository.addUserDetails(details);
  }
}