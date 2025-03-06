import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_photo_use_case.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_usecase.dart';

abstract class IAuthRepository {
  Future<Either<Failure, String>> loginUser(String email, String password);
  Future<Either<Failure, void>> registerUser(AuthEntity user);
  Future<Either<Failure, String>> uploadProfilePicture(File file);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, AuthEntity>> updateProfile(UpdateProfileParams params);
  Future<Either<Failure, AuthEntity>> uploadProfilePhoto(UploadProfilePhotoParams params);
}