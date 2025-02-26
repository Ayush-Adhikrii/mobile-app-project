import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_photo_use_case.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entity/auth_entity.dart';
import '../../../domain/repository/auth_repository.dart';
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
    String email,
    String password,
  ) async {
    try {
      final token = await _authLocalDataSource.loginUser(email, password);
      return Right(token);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(AuthEntity user) async {
    try {
      return Right(_authLocalDataSource.registerUser(user));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthEntity>> updateProfile(UpdateProfileParams params) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthEntity>> uploadProfilePhoto(UploadProfilePhotoParams params) {
    // TODO: implement uploadProfilePhoto
    throw UnimplementedError();
  }
}
