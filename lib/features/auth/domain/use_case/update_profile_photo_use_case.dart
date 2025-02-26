// lib/features/auth/domain/usecases/upload_profile_photo_usecase.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';

import '../repository/auth_repository.dart';

class UploadProfilePhotoUseCase {
  final IAuthRepository repository;

  UploadProfilePhotoUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call(UploadProfilePhotoParams params) async {
    return await repository.uploadProfilePhoto(params);
  }
}

class UploadProfilePhotoParams extends Equatable {
  final String userId;
  final File image;

  const UploadProfilePhotoParams({required this.userId, required this.image});

  @override
  List<Object> get props => [userId, image];
}