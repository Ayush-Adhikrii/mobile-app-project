// lib/features/preference/domain/usecases/update_preference_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/preference_entity.dart';
import '../repository/preference_repository.dart';

class UpdatePreferenceUseCase {
  final IPreferenceRepository repository;

  UpdatePreferenceUseCase(this.repository);

  Future<Either<Failure, PreferenceEntity>> call(
      String userId, PreferenceEntity preference) async {
    return await repository.updatePreference(userId, preference);
  }
}
