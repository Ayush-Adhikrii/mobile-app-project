// lib/features/preference/domain/usecases/get_preference_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/preference_entity.dart';
import '../repository/preference_repository.dart';

class GetPreferenceUseCase {
  final IPreferenceRepository repository;

  GetPreferenceUseCase(this.repository);

  Future<Either<Failure, PreferenceEntity>> call(String userId) async {
    return await repository.getPreference(userId);
  }
}