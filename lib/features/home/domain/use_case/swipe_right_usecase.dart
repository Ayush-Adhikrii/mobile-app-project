
// lib/features/home/domain/usecases/swipe_right_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/repository/user_repository.dart';

class SwipeRightUseCase {
  final IUserRepository repository;

  SwipeRightUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId) async {
    return await repository.swipeRight(userId);
  }
}