// lib/features/preference/data/repositories/preference_remote_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entity/preference_entity.dart';
import '../../domain/repository/preference_repository.dart';
import '../data_source/preference_remote_data_source.dart';

class PreferenceRemoteRepository implements IPreferenceRepository {
  final PreferenceRemoteDataSource remoteDataSource;

  PreferenceRemoteRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, PreferenceEntity>> getPreference(String userId) async {
    try {
      final preference = await remoteDataSource.getPreference(userId);
      return Right(preference);
    } catch (e) {
      return Left(ApiFailure(message:  e.toString()));
    }
  }

  @override
  Future<Either<Failure, PreferenceEntity>> updatePreference(String userId, PreferenceEntity preference) async {
    try {
      final updatedPreference = await remoteDataSource.updatePreference(userId, preference);
      return Right(updatedPreference);
    } catch (e) {
      return Left(ApiFailure(message:  e.toString()));
    }
  }
}