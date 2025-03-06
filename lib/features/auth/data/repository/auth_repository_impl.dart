import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/core/network/connectivity_service.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/repository/auth_local_repository/auth_local_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/repository/auth_remote_repository/auth_remote_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/repository/auth_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_photo_use_case.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_usecase.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteRepository remoteRepository;
  final AuthLocalRepository localRepository;
  final ConnectivityService connectivityService;

  AuthRepositoryImpl({
    required this.remoteRepository,
    required this.localRepository,
    required this.connectivityService,
  });

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    if (connectivityService.isConnected) {
      return await remoteRepository.getCurrentUser();
    } else {
      return await localRepository.getCurrentUser();
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
      String email, String password) async {
    if (connectivityService.isConnected) {
      return await remoteRepository.loginUser(email, password);
    } else {
      return await localRepository.loginUser(email, password);
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(AuthEntity user) async {
    if (connectivityService.isConnected) {
      return await remoteRepository.registerUser(user);
    } else {
      return await localRepository.registerUser(user);
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    if (connectivityService.isConnected) {
      return await remoteRepository.uploadProfilePicture(file);
    } else {
      return Left(LocalDatabaseFailure(
          message:
              'No internet connection: Profile picture upload not supported offline'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> updateProfile(
      UpdateProfileParams params) async {
    if (connectivityService.isConnected) {
      return await remoteRepository.updateProfile(params);
    } else {
      return await localRepository.updateProfile(params);
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> uploadProfilePhoto(
      UploadProfilePhotoParams params) async {
    if (connectivityService.isConnected) {
      return await remoteRepository.uploadProfilePhoto(params);
    } else {
      return await localRepository.uploadProfilePhoto(params);
    }
  }
}
