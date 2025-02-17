import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/auth_entity.dart';
import '../repository/auth_repository.dart';

class RegisterUserParams extends Equatable {
  final String name;
  final String? email;
  final String? phoneNumber;
  final String userName;
  final String password;
  final String? gender;
  final String? birthDate;
  final String? starSign;
  final String? bio;
  final String? profilePhoto;

  const RegisterUserParams({
    required this.name,
    this.email,
    this.phoneNumber,
    required this.userName,
    required this.password,
    this.gender,
    this.birthDate,
    this.starSign,
    this.bio,
    this.profilePhoto,
  });

  const RegisterUserParams.initial({
    required this.name,
    this.email,
    this.phoneNumber,
    required this.userName,
    required this.password,
    this.gender,
    this.birthDate,
    this.starSign,
    this.bio,
    this.profilePhoto,
  });

  const RegisterUserParams.empty()
      : name = 'empty_user_id',
        email = 'empty_user_email',
        phoneNumber = 'empty_user_phonenumber',
        gender = 'empty_user_gender',
        birthDate = null,
        starSign = 'empty_user_starsign',
        bio = 'empty_user_bio',
        userName = 'empty_user_username',
        password = 'empty_user_password',
        profilePhoto = 'empty_user_photo';

  @override
  List<Object?> get props => [
        name,
        email,
        phoneNumber,
        password,
        gender,
        birthDate,
        starSign,
        bio,
        profilePhoto,
      ];
}

class RegisterUseCase implements UsecaseWithParams<void, RegisterUserParams> {
  final IAuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final authEntity = AuthEntity(
      name: params.name,
      email: params.email,
      phoneNumber: params.phoneNumber,
      password: params.password,
      userName: params.userName,
      gender: params.gender,
      birthDate: params.birthDate,
      starSign: params.starSign,
      bio: params.bio,
      profilePhoto: params.profilePhoto,
    );
    return repository.registerUser(authEntity);
  }
}
