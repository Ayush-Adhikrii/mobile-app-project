import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:softwarica_student_management_bloc/app/usecase/usecase.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/repository/auth_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';

class RegisterUserParams extends Equatable {
  final String name;
  final String? email;
  final String? phoneNumber;
  final String userName;
  final String password;
  final String? gender;
  final DateTime? birthDate;
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
