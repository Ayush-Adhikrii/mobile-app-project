import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/repository/auth_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_photo_use_case.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_usecase.dart';

import '../../data_source/local_data_source/auth_local_datasource.dart';

class AuthLocalRepository implements IAuthRepository {
  final AuthLocalDataSource _authLocalDataSource;

  AuthLocalRepository(this._authLocalDataSource);

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final currentUser = await _authLocalDataSource.getCurrentUser();
      return Right(currentUser);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
      String email, String password) async {
    try {
      final (token, user) =
          await _authLocalDataSource.loginUser(email, password);
      return Right(token);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(AuthEntity user) async {
    try {
      await _authLocalDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final photoUrl = await _authLocalDataSource.uploadProfilePicture(file);
      return Right(photoUrl);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> updateProfile(
      UpdateProfileParams params) async {
    try {
      final currentUser = await _authLocalDataSource.getCurrentUser();
      final updatedUser = AuthEntity(
        userId: currentUser.userId,
        name: currentUser.name,
        email: currentUser.email,
        phoneNumber: currentUser.phoneNumber,
        userName: currentUser.userName,
        password: currentUser.password,
        gender: currentUser.gender,
        birthDate: params.birthDate.toIso8601String(),
        starSign: currentUser.starSign,
        bio: currentUser.bio,
        profilePhoto: currentUser.profilePhoto,
      );
      await _authLocalDataSource.registerUser(updatedUser); // Update in Hive
      return Right(updatedUser);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> uploadProfilePhoto(
      UploadProfilePhotoParams params) async {
    try {
      final currentUser = await _authLocalDataSource.getCurrentUser();
      final updatedUser = AuthEntity(
        userId: currentUser.userId,
        name: currentUser.name,
        email: currentUser.email,
        phoneNumber: currentUser.phoneNumber,
        userName: currentUser.userName,
        password: currentUser.password,
        gender: currentUser.gender,
        birthDate: currentUser.birthDate,
        starSign: currentUser.starSign,
        bio: currentUser.bio,
        profilePhoto: currentUser.profilePhoto,
      );
      await _authLocalDataSource.registerUser(updatedUser); // Update in Hive
      return Right(updatedUser);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
