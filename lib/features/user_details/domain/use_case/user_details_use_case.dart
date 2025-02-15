import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/user_details_entity.dart';
import '../repository/user_details_repository.dart';

class AddUserDetailsParams extends Equatable {
  final String userId;
  final String? profession;
  final String? education;
  final double? height;
  final String? exercise;
  final String? drinks;
  final String? smoke;
  final String? kids;
  final String? religion;

  const AddUserDetailsParams({
    required this.userId,
    this.profession,
    this.education,
    this.height,
    this.exercise,
    this.drinks,
    this.smoke,
    this.kids,
    this.religion,
  });

  const AddUserDetailsParams.initial({
    required this.userId,
    this.profession,
    this.education,
    this.height,
    this.exercise,
    this.drinks,
    this.smoke,
    this.kids,
    this.religion,
  });

  const AddUserDetailsParams.empty()
      : userId = 'empty_user_id',
        profession = 'empty_profession',
        education = 'empty_education',
        height = 0.0,
        exercise = 'empty_exercise',
        drinks = 'empty_drinks',
        smoke = 'empty_smoke',
        kids = 'empty_kids',
        religion = 'empty_religion';

  @override
  List<Object?> get props => [
        userId,
        profession,
        education,
        height,
        exercise,
        drinks,
        smoke,
        kids,
        religion,
      ];
}

class UserDetailsUseCase
    implements UsecaseWithParams<void, AddUserDetailsParams> {
  final IUserDetailsRepository repository;

  UserDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddUserDetailsParams params) {
    final userDetailsEntity = UserDetailsEntity(
      userId: params.userId,
      profession: params.profession,
      education: params.education,
      height: params.height,
      exercise: params.exercise,
      drinks: params.drinks,
      smoke: params.smoke,
      kids: params.kids,
      religion: params.religion,
    );
    return repository.addDetails(userDetailsEntity);
  }
}
