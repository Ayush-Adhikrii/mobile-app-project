// lib/features/home/data/datasources/user_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/entity/user_entity.dart';

abstract class UserRemoteDataSource {
  Future<List<UserEntity>> getUsers();
  Future<List<UserEntity>> getLikers(String userId);
  Future<void> swipeLeft(String userId);
  Future<void> swipeRight(String userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSourceImpl(this._dio);

  @override
  Future<List<UserEntity>> getUsers() async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.baseUrl}matches/user-profiles',
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['users'] is List) {
          return (data['users'] as List)
              .map((json) => UserEntity.fromJson(json))
              .toList();
        } else if (data is List) {
          return data.map((json) => UserEntity.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected response format: $data');
        }
      } else {
        throw Exception('Failed to fetch users: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in getUsers: ${e.type}, Message: ${e.message}, Response: ${e.response?.data}, Error: ${e.error}');
      throw Exception(
          'Failed to fetch users: ${e.message ?? 'Unknown network error'}');
    } catch (e) {
      print('Unexpected error in getUsers: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<UserEntity>> getLikers(String userId) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.baseUrl}matches/likers/$userId',
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => UserEntity.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected response format: $data');
        }
      } else if (response.statusCode == 404) {
        return []; // Return empty list for 404
      } else {
        throw Exception('Failed to fetch likers: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in getLikers: ${e.type}, Message: ${e.message}, Response: ${e.response?.data}, Error: ${e.error}');
      if (e.response?.statusCode == 404) {
        return []; // Handle 404 by returning empty list
      }
      throw Exception(
          'Failed to fetch likers: ${e.message ?? 'Unknown network error'}');
    } catch (e) {
      print('Unexpected error in getLikers: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> swipeLeft(String userId) async {
    try {
      final response =
          await _dio.post('${ApiEndpoints.baseUrl}matches/swipe-left/$userId');
      print('Swipe left response: ${response.statusCode}, ${response.data}');
      if (response.statusCode != 200) {
        throw Exception('Failed to swipe left: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in swipeLeft: ${e.message}, Response: ${e.response?.data}');
      throw Exception('Failed to swipe left: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      print('Unexpected error in swipeLeft: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> swipeRight(String userId) async {
    try {
      final response =
          await _dio.post('${ApiEndpoints.baseUrl}matches/swipe-right/$userId');
      print('Swipe right response: ${response.statusCode}, ${response.data}');
      if (response.statusCode != 200) {
        throw Exception('Failed to swipe right: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in swipeRight: ${e.message}, Response: ${e.response?.data}');
      throw Exception('Failed to swipe right: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      print('Unexpected error in swipeRight: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}