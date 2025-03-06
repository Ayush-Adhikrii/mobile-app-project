import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/data_source/local_data_source/auth_local_datasource.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/repository/auth_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_photo_use_case.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_usecase.dart';

class AuthRemoteRepository implements IAuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRemoteRepository(this._authRemoteDataSource, this._authLocalDataSource);

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final user = await _authRemoteDataSource.getCurrentUser();
      await _authLocalDataSource.registerUser(user); // Cache in Hive
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
      String userName, String password) async {
    try {
      final (token, user) =
          await _authRemoteDataSource.loginUser(userName, password);
      await _authLocalDataSource.registerUser(user); // Cache in Hive
      return Right(token);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(AuthEntity user) async {
    try {
      final registeredUser = await _authRemoteDataSource.registerUser(user);
      await _authLocalDataSource.registerUser(registeredUser); // Cache in Hive
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final imageName = await _authRemoteDataSource.uploadProfilePicture(file);
      // Fetch the updated user, but don't fail the operation if it fails
      try {
        final user = await _authRemoteDataSource.getCurrentUser();
        await _authLocalDataSource.registerUser(user); // Update cache in Hive
      } catch (e) {
        print('Failed to fetch updated user after image upload: $e');
      }
      return Right(imageName);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> updateProfile(
      UpdateProfileParams params) async {
    try {
      final user = await _authRemoteDataSource.updateProfile(params);
      await _authLocalDataSource.registerUser(user); // Update cache in Hive
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> uploadProfilePhoto(
      UploadProfilePhotoParams params) async {
    try {
      final user = await _authRemoteDataSource.uploadProfilePhoto(params);
      await _authLocalDataSource.registerUser(user); // Update cache in Hive
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
