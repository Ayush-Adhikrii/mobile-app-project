import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/auth_entity.dart';
import '../use_case/update_profile_photo_use_case.dart';
import '../use_case/update_profile_usecase.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, void>> registerUser(AuthEntity user);

  Future<Either<Failure, String>> loginUser(String userName, String password);

  Future<Either<Failure, String>> uploadProfilePicture(File file);

  Future<Either<Failure, AuthEntity>> getCurrentUser();

  Future<Either<Failure, AuthEntity>> updateProfile(UpdateProfileParams params);
  Future<Either<Failure, AuthEntity>> uploadProfilePhoto(
      UploadProfilePhotoParams params);
}
