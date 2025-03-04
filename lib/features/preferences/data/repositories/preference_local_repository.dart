// // lib/features/preference/data/repositories/preference_local_repository.dart
// import 'package:dartz/dartz.dart';
// import 'package:softwarica_student_management_bloc/core/error/failure.dart';
// import 'package:softwarica_student_management_bloc/features/preference/data/datasources/preference_local_datasource.dart';
// import 'package:softwarica_student_management_bloc/features/preference/domain/entities/preference_entity.dart';
// import 'package:softwarica_student_management_bloc/features/preference/domain/repositories/preference_repository.dart';

// class PreferenceLocalRepository implements IPreferenceRepository {
//   final PreferenceLocalDataSource localDataSource;

//   PreferenceLocalRepository(this.localDataSource);

//   @override
//   Future<Either<Failure, PreferenceEntity>> getPreference(String userId) async {
//     try {
//       final preference = await localDataSource.getPreference(userId);
//       if (preference != null) {
//         return Right(preference);
//       } else {
//         return Left(CacheFailure('No preference found in local storage'));
//       }
//     } catch (e) {
//       return Left(CacheFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, PreferenceEntity>> updatePreference(String userId, PreferenceEntity preference) async {
//     try {
//       await localDataSource.savePreference(preference);
//       return Right(preference);
//     } catch (e) {
//       return Left(CacheFailure(e.toString()));
//     }
//   }
// }