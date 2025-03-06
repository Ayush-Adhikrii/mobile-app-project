import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/core/network/connectivity_service.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/entity/user_details_entity.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/repository/user_details_repository.dart';

import 'auth_local_repository/user_details_local_repository.dart';
import 'auth_remote_repository/user_details_remote_repository.dart';

class UserDetailsRepositoryImpl implements IUserDetailsRepository {
  final UserDetailsRemoteRepository remoteRepository;
  final UserDetailsLocalRepository localRepository;
  final ConnectivityService connectivityService;

  UserDetailsRepositoryImpl({
    required this.remoteRepository,
    required this.localRepository,
    required this.connectivityService,
  });

  @override
  Future<Either<Failure, void>> addUserDetails(UserDetailsEntity user) async {
    if (connectivityService.isConnected) {
      print('Adding user details via remote repository');
      return await remoteRepository.addUserDetails(user);
    } else {
      print('Adding user details via local repository');
      return await localRepository.addUserDetails(user);
    }
  }

  @override
  Future<Either<Failure, UserDetailsEntity>> getUserDetails({required String userId}) async {
    if (connectivityService.isConnected) {
      print('Fetching user details from remote repository for userId: $userId');
      return await remoteRepository.getUserDetails(userId);
    } else {
      print('Fetching user details from local repository for userId: $userId');
      return await localRepository.getUserDetails(userId);
    }
  }

  @override
  Future<Either<Failure, void>> updateUserDetails(String userId, String key, String value) async {
    if (connectivityService.isConnected) {
      print('Updating user details via remote repository for userId: $userId');
      return await remoteRepository.updateUserDetails(userId, key, value);
    } else {
      print('Updating user details via local repository for userId: $userId');
      return await localRepository.updateUserDetails(userId, key, value);
    }
  }
}