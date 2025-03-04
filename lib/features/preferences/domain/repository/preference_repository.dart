// lib/features/preference/domain/repositories/preference_repository.dart
import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import '../entity/preference_entity.dart';

abstract class IPreferenceRepository {
  Future<Either<Failure, PreferenceEntity>> getPreference(String userId);
  Future<Either<Failure, PreferenceEntity>> updatePreference(String userId, PreferenceEntity preference);
}