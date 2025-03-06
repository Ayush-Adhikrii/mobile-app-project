import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/core/network/connectivity_service.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/entity/user_entity.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/repository/user_repository.dart';

import 'local_repository/user_local_repository.dart';
import 'remote_repository/user_remote_repository.dart';

class UserRepositoryImpl implements IUserRepository {
  final UserRemoteRepository remoteRepository;
  final UserLocalRepository localRepository;
  final ConnectivityService connectivityService;

  UserRepositoryImpl({
    required this.remoteRepository,
    required this.localRepository,
    required this.connectivityService,
  });

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    if (connectivityService.isConnected) {
      print('Fetching users from remote repository');
      return await remoteRepository.getUsers();
    } else {
      print('Fetching users from local repository');
      return await localRepository.getUsers();
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getLikers(String userId) async {
    if (connectivityService.isConnected) {
      print('Fetching likers from remote repository for userId: $userId');
      return await remoteRepository.getLikers(userId);
    } else {
      print('Fetching likers from local repository for userId: $userId');
      return await localRepository.getLikers(userId);
    }
  }

  @override
  Future<Either<Failure, void>> swipeLeft(String userId) async {
    if (connectivityService.isConnected) {
      print('Swiping left via remote repository for userId: $userId');
      return await remoteRepository.swipeLeft(userId);
    } else {
      print('Swiping left via local repository for userId: $userId');
      return await localRepository.swipeLeft(userId);
    }
  }

  @override
  Future<Either<Failure, void>> swipeRight(String userId) async {
    if (connectivityService.isConnected) {
      print('Swiping right via remote repository for userId: $userId');
      return await remoteRepository.swipeRight(userId);
    } else {
      print('Swiping right via local repository for userId: $userId');
      return await localRepository.swipeRight(userId);
    }
  }
}