// lib/features/auth/data/repository/auth_remote_repository.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/repository/auth_repository.dart';

import '../../../domain/use_case/update_profile_photo_use_case.dart';
import '../../../domain/use_case/update_profile_usecase.dart';

class AuthRemoteRepository implements IAuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRemoteRepository(this._authRemoteDataSource);

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final user = await _authRemoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(String userName, String password) async {
    try {
      final token = await _authRemoteDataSource.loginUser(userName, password);
      return Right(token);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(AuthEntity user) async {
    try {
      await _authRemoteDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final imageName = await _authRemoteDataSource.uploadProfilePicture(file);
      return Right(imageName);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> updateProfile(UpdateProfileParams params) async {
    try {
      final user = await _authRemoteDataSource.updateProfile(params);
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> uploadProfilePhoto(UploadProfilePhotoParams params) async {
    try {
      final user = await _authRemoteDataSource.uploadProfilePhoto(params);
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}