// lib/features/preference/data/datasources/preference_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';

import '../../domain/entity/preference_entity.dart';
import '../model/preferences_api_model.dart';

abstract class PreferenceRemoteDataSource {
  Future<PreferenceEntity> getPreference(String userId);
  Future<PreferenceEntity> updatePreference(
      String userId, PreferenceEntity preference);
}

class PreferenceRemoteDataSourceImpl implements PreferenceRemoteDataSource {
  final Dio _dio;

  PreferenceRemoteDataSourceImpl(this._dio);

  @override
  Future<PreferenceEntity> getPreference(String userId) async {
    try {
      final response =
          await _dio.get('${ApiEndpoints.baseUrl}preference/$userId');
      print('getPreference response: ${response.statusCode}, ${response.data}');
      if (response.statusCode == 200) {
        // Explicitly return as PreferenceEntity (safe since PreferencesApiModel extends it)
        final preference = PreferencesApiModel.fromJson(response.data);
        return preference.toEntity(); // No cast needed due to inheritance
      } else {
        throw Exception(
            'Failed to fetch preference: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in getPreference: ${e.message}, Response: ${e.response?.data}');
      throw Exception(
          'Failed to fetch preference: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      print('Unexpected error in getPreference: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<PreferenceEntity> updatePreference(
      String userId, PreferenceEntity preference) async {
    try {
      // Convert PreferenceEntity to PreferencesApiModel for JSON serialization
      final apiModel = PreferencesApiModel(
        userId: preference.userId,
        preferredGender: preference.preferredGender,
        minAge: preference.minAge,
        maxAge: preference.maxAge,
        relationType: preference.relationType,
        preferredStarSign: preference.preferredStarSign,
        preferredReligion: preference.preferredReligion,
      );
      final response = await _dio.put(
        '${ApiEndpoints.baseUrl}preference/$userId',
        data: apiModel.toJson(),
      );
      print(
          'updatePreference response: ${response.statusCode}, ${response.data}');
      if (response.statusCode == 200) {
        final model = PreferencesApiModel.fromJson(response.data);
        final entity = model.toEntity();
        return entity;
      } else {
        throw Exception(
            'Failed to update preference: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in updatePreference: ${e.message}, Response: ${e.response?.data}');
      throw Exception(
          'Failed to update preference: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      print('Unexpected error in updatePreference: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
