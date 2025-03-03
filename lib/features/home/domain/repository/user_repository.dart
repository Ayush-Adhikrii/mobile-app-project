// lib/features/home/domain/repository/user_repository.dart
import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/entity/user_entity.dart';

abstract class IUserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers();
  Future<Either<Failure, void>> swipeLeft(String userId);
  Future<Either<Failure, void>> swipeRight(String userId);
}