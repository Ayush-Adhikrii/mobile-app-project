import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/data_source/auth_data_source.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_photo_use_case.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_usecase.dart';

class AuthRemoteDataSource implements IAuthDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  @override
  Future<AuthEntity> registerUser(AuthEntity user) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}auth/signup',
        data: user.toJson(),
      );
      if (response.statusCode == 201) {
        final userId = response.data['user']['_id'] as String;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('current_user_id', userId);
        // Use the plain-text password from the input
        return AuthEntity.fromJson(response.data['user'])
            .copyWith(password: user.password);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to register user: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to register user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  @override
  Future<(String, AuthEntity)> loginUser(
      String userName, String password) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}auth/login',
        data: {'userName': userName, 'password': password},
      );
      if (response.statusCode == 200) {
        final token = response.data['token'] as String;
        final userId = response.data['user']['_id'] as String;
        final user = AuthEntity.fromJson(response.data['user'])
            .copyWith(password: password);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('current_user_id', userId);
        await prefs.setString('jwt_token', token); // Save the token
        return (token, user);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to login: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      final formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}auth/uploadImage',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      if (response.statusCode == 200) {
        return response.data['data'] as String;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to upload profile picture: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to upload profile picture: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  @override
  Future<AuthEntity> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('current_user_id');
      if (userId == null) {
        throw Exception('No user logged in');
      }
      final response = await _dio.get('${ApiEndpoints.baseUrl}auth/me');
      if (response.statusCode == 200) {
        return AuthEntity.fromJson(response.data['user']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to fetch current user: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch current user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch current user: $e');
    }
  }

  Future<AuthEntity> updateProfile(UpdateProfileParams params) async {
    try {
      final response = await _dio.put(
        '${ApiEndpoints.baseUrl}auth/update/${params.userId}',
        data: params.toJson(),
      );
      if (response.statusCode == 200) {
        return AuthEntity.fromJson(response.data['user']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to update profile: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<AuthEntity> uploadProfilePhoto(UploadProfilePhotoParams params) async {
    try {
      final formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(
          params.image.path,
          filename: params.image.path.split('/').last,
        ),
      });
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}auth/uploadImage',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      if (response.statusCode == 200) {
        return await getCurrentUser();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to upload profile photo: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to upload profile photo: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload profile photo: $e');
    }
  }
}
