// lib/features/auth/domain/usecases/update_profile_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';

import '../repository/auth_repository.dart';

class UpdateProfileUseCase {
  final IAuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(params);
  }
}

class UpdateProfileParams extends Equatable {
  final String userId;
  final String name;
  final String gender;
  final String email;
  final DateTime birthDate;
  final String starSign;
  final String phoneNumber;
  final String bio;
  final String userName;

  const UpdateProfileParams({
    required this.userId,
    required this.name,
    required this.gender,
    required this.email,
    required this.birthDate,
    required this.starSign,
    required this.phoneNumber,
    required this.bio,
    required this.userName,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'gender': gender,
        'email': email,
        'birthDate': birthDate.toIso8601String(),
        'starSign': starSign,
        'phoneNumber': phoneNumber,
        'bio': bio,
        'userName': userName,
      };

  @override
  List<Object> get props => [
        userId,
        name,
        gender,
        email,
        birthDate,
        starSign,
        phoneNumber,
        bio,
        userName
      ];
}
